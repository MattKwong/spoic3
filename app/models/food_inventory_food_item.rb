# == Schema Information
# Schema version: 20110331025929
#
# Table name: food_inventory_food_items
#
#  id                :integer         not null, primary key
#  food_inventory_id :integer
#  item_id      :integer
#  quantity          :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  in_base_units     :decimal(, )
#  in_inventory      :decimal(, )
#  average_cost      :decimal(, )
#

class FoodInventoryFoodItem < ActiveRecord::Base
  attr_accessible :item_id, :quantity, :food_inventory_id, :in_inventory, :average_cost

  belongs_to :item
  belongs_to :food_inventory

  validates :food_inventory_id, :presence => true
  validates :item_id, :presence => true
  validate :validate_units
  # validates :quantity, :presence => true
#  default_scope :order =>  'created_at DESC'
  scope :for_item, lambda {|food_item| where('item_id = ?', food_item.id) }

  scope :for_program, lambda { |program| includes(:food_inventory).where('food_inventories.program_id = ?', program.id) }

  scope :after, lambda { |date| includes(:food_inventory).where('food_inventories.date >= ?', date) }
  scope :alphabetized, :include => :item, :order => 'items.name'
  # action callbacks
  before_save :update_calculated_fields, :unless => :skip_calculations?
#  after_save :update_derived_fields, :unless => Proc.new {|item| item.skip_calculations? || item.skip_derivations? }
#  after_destroy :update_derived_fields, :unless => Proc.new {|item| item.skip_calculations? || item.skip_derivations? }

  def consumed
    in_inventory - in_base_units
  end

  def consumed_units
    "#{consumed} #{item.base_unit}"
  end
  
  def in_inventory_units
    "#{in_inventory} #{item.base_unit}"
  end

  def total_price
    ave_cost * consumed
  end

  def total_consumed_cost
    ave_cost * consumed
  end

  def total_inventoried_cost
    ave_cost * in_base_units
  end

  def total_starting_inventory_cost
    ave_cost * in_inventory
  end

  def update_calculated_fields
    update_base_units
    #update_in_inventory
    #update_average_cost
  end

  def update_derived_fields
    FoodInventoryFoodItem.for_item(item).for_program(food_inventory.program).after(food_inventory.date).each do |item|
      unless item.id == self.id
        item.skip_derivations = true
        item.save
      end
    end
  end

  def update_in_inventory
    self.in_inventory = item.in_inventory_for_program_at(food_inventory.program, food_inventory.date)
  end


  def skip_derivations=(skip)
    @skip_derivations = skip
  end

  def skip_derivations?
    @skip_derivations
  end

  def skip_calculations=(skip)
    @skip_calculations = skip
  end

  def skip_calculations?
    @skip_calculations
  end

  private

  def ave_cost
    average_cost || item.item_purchases.for_program(food_inventory.program).last.price || 0
  end

  def update_base_units
    self.in_base_units = self.quantity.u.to(self.item.base_unit).abs
  end

  def update_average_cost
    self.average_cost = item.cost_of(food_inventory.program, food_inventory.date, consumed_units, quantity)

  end

  def validate_units
    begin
      self.quantity.unit
      errors.add(:quantity, "Base unit should be a unit of weight, length, volume, or each") unless [:unitless, :length, :mass, :volume].include? self.quantity.unit.kind
      errors.add(:quantity, "the units entered are a measure of #{self.quantity.unit.kind.to_s.humanize}, while #{self.item.name} requires a unit of #{self.item.base_unit.unit.kind.to_s.humanize} to convert") unless(self.item.nil? || self.item.base_unit.unit =~ self.quantity.unit)
    rescue Exception => e
      #errors.add(:quantity, e.message)
      errors.add(:quantity, "#{self.quantity} does not use recognized units")
    end
  end


end
