class ItemPurchase < ActiveRecord::Base
  attr_accessible :item_id, :purchase_id, :quantity, :size, :price, :taxable, :uom, :total_base_units

  belongs_to :item
  belongs_to :purchase

  validates :item_id, :presence => true
  validates :purchase_id, :presence => true
  validates :quantity, :presence => true
  validates :price, :presence => true
  validates :taxable, :inclusion => [true, false]
  validates :size, :presence => true
  validate :validate_units

  scope :by_budget_line_type, lambda { |id| joins(:item).where("budget_item_type_id = ?", id) }
  scope :for_program, lambda { |program| joins(:purchase).where('purchases.program_id = ?', program) }
  scope :for_program_budget_line_type, lambda { |program_id, budget_line_id| joins(:purchase).where('purchase.program_id = ?', program_id) }
  scope :for_program_tracked, lambda { |id| joins(:item, :purchase).where("purchases.program_id = ? AND budget_item_type_id = ? AND untracked = ?", id, 1, 'f') }
  scope :for_program_untracked, lambda { |id| joins(:item, :purchase).where("purchases.program_id = ? AND budget_item_type_id = ? AND untracked != ?", id, 1, 'f') }

  scope :for_item, lambda { |item| joins(:item).where('item_id = ?', item) }
  scope :taxable, where(:taxable => true)
  scope :alphabetized, joins(:item).order('items.name')
  scope :by_date, joins(:purchase).order('purchases.date')
  scope :between_dates, lambda { |start_date, end_date| joins(:purchase).where('purchases.date >= ? AND purchases.date < ?', start_date, end_date) }


#  after_save :update_derived_fields, :unless => Proc.new { skip_calculations? || skip_derivations? }
#  after_destroy :update_derived_fields, :unless => Proc.new { skip_calculations? || skip_derivations? }

  before_save :update_base_units, :unless => :skip_calculations?

  def size_in_base_units
    size.u >> item.base_unit
  end

  def items_by_budget_item_type_id
    self.item.budget_item_type_id
  end

  def total_size
    size.u * quantity
   end

  def total_size_in_base_units
    size_in_base_units * quantity
  end

  def total_price
    price * quantity
  end

  def total_price_with_tax
    taxable? ? price * quantity * (1 + purchase.actual_tax_rate) : price * quantity
  end

  def price_per_base_unit
    price / size_in_base_units
  end

  def skip_calculations=(skip)
    @_skip = true
  end

  def skip_calculations?
    @_skip
  end

  def skip_derivations=(skip)
    @skip_der = skip
  end

  def skip_derivations?
    @skip_der
  end

  private

  def update_base_units
    self.total_base_units = (self.quantity * self.size.u).to(self.item.base_unit).abs
  end

  def update_derived_fields
    FoodInventoryFoodItem.for_item(item).for_program(purchase.program).after(purchase.date).each do |item|
      item.save
    end
  end

  def validate_units
    begin
      self.size.unit
      errors.add(:size, "Base unit should be a unit of length, weight, volume, or each") unless [:unitless, :length, :mass, :volume].include? self.size.unit.kind
      errors.add(:size, "the units entered are a measure of #{self.size.unit.kind.to_s.humanize}, while #{self.item.name} requires a unit of #{self.item.base_unit.unit.kind.to_s.humanize} to convert") unless self.item.base_unit.unit =~ self.size.unit
    rescue
      errors.add(:size, "#{self.size} does not use recognized units")
    end
  end

end

