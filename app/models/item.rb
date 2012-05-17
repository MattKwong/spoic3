class Item < ActiveRecord::Base
    attr_accessible :name, :base_unit, :default_taxed, :item_category_id, :item_type_id,
                    :program_id, :budget_item_type_id, :description

    validates :base_unit, :name, :item_type_id, :budget_item_type_id, :item_category_id,
              :description, :presence => true

    validates :default_taxed, :inclusion => [true, false]

    validate :validate_units
    validate :validate_name

    before_save :strip_units_scalar

    belongs_to :program
    belongs_to :item_category
    belongs_to :item_type
    belongs_to :budget_item_type

    has_many :item_purchases, :dependent => :restrict
    has_many :purchases, :through => :item_purchases
    has_many :food_inventory_food_items, :dependent => :restrict
    has_many :food_inventories, :through => :food_inventory_food_items
    has_many :material_item_delivereds, :dependent => :restrict
    has_many :material_item_estimateds, :dependent => :restrict


    scope :food, lambda {joins(:budget_item_type).where("budget_item_types.name = 'Food'" ) }
    scope :materials, lambda {joins(:budget_item_type).where("budget_item_types.name = 'Materials'" ) }
    scope :tools, lambda {joins(:budget_item_type).where("budget_item_types.name = 'Tools'" ) }
    scope :gas, lambda {joins(:budget_item_type).where("budget_item_types.name = 'Gas'" ) }
    scope :other, lambda {joins(:budget_item_type).where("budget_item_types.name = 'Other'" ) }

    scope :master, where(:program_id => nil)
    scope :all_for_program, lambda {|program| where('program_id IS NULL OR program_id = ?', program.id) }
    scope :alphabetized, order("name")

    scope :search_by_name, lambda { |q| (q ? where(["name Like ?", '%' + q + '%']) : {} ) }


    after_save :rebase_units

    def food?
      self.budget_item_type.name == "Food"
    end

    def to_s
      name
    end

    def last_inventory_for_program_at_date(program, date)
      food_inventory_food_items.joins(:food_inventory).where('food_inventories.program_id = ? and food_inventories.date < ?', program.id, date).order('food_inventories.date DESC').first
    end

    def last_inventory_for(program)
      last_inventory_for_program_at_date(program, Date.today)
    end

    def purchases_between(program, start_date, end_date)
      item_purchases.joins(:purchase).where('purchases.program_id = ? AND purchases.date >= ? AND purchases.date < ?', program.id, start_date, end_date)
    end
#These methods are used to calculate the current on hand quantities of construction materials
    def program_purchases(program)
      p = item_purchases.joins(:purchase).where('purchases.program_id = ?', program.id)
      total = 0
      p.each {|i| total += i.quantity }
      total
    end

    def program_deliveries(program)
      p = material_item_delivereds.joins(:project).where('projects.program_id = ?', program.id)
      total = 0
      p.each {|i| total += i.quantity }
      total
    end

    def construction_onhand(program)
      program_purchases(program) - program_deliveries(program)
    end

    def in_inventory_for(program)
     in_inventory_for_program_at(program, Date.today)
    end

    def purchased_for_program(program, start_date, end_date)
      purchases_between(program, start_date, end_date).inject(0) do |total, purchase|
        temp =  purchase.quantity * purchase.size.u
      end
    end

    def average_cost(program, date)
      p = purchases_between(program, program.start_date, program.end_date)
      num = (p.inject(0) {|t, i| t += i.quantity * i.price })
      denom = ( p.inject(0) {|t,i| t += i.total_base_units})
      denom == 0 ? 0 : num/denom
    end

    def in_inventory_for_program_at(program, date)
      last_inventory = last_inventory_for_program_at_date(program, date)
      if last_inventory.nil?
        (purchases_between(program, program.start_date, date).map &:total_base_units).sum
      else
        last_inventory.in_base_units + (purchases_between(program, last_inventory.food_inventory.date, date).map &:total_base_units).sum
      end
    end

    def cost_of_inventory(program, date)
      logger.debug "#{in_inventory_for_program_at(program, date)} #{base_unit}"
      cost_of(program, date, "#{in_inventory_for_program_at(program, date)} #{base_unit}").scalar

    end

    # returns the price per base unit.  The value returned is unitless
    def cost_of(program, date, quantity, excluded = 0)
      item_purchases = purchases_between(program, program.start_date, date).order('date DESC')
      # food_item_purchases = Purchase.for_program(program).after(program.start_date).before(date).order('date DESC')

      costs = []
      quantity = quantity.unit.to(base_unit).abs
      unless excluded == 0
        excluded = excluded.unit.to(base_unit).abs
      end

      item_purchases.each do |food_item_purchase|
        amount_available = Unit.new("#{food_item_purchase.total_base_units} #{food_item_purchase.item.base_unit}")
        if excluded > 0
          to_debit = [excluded, amount_available].min
          excluded -= to_debit
          amount_available -= to_debit
        end

        if quantity > 0
          to_debit = [quantity, amount_available].min
          quantity -= to_debit
          costs << [to_debit, food_item_purchase.price_per_base_unit]
        end
      end

      denom = (costs.collect {|e| e[0] }).sum
      num = (costs.inject(0) { |result, element| result + element[0].unit * element[1] })
      denom == 0 ? 0.u : num / denom
    end

    protected

    def validate_units
      self.base_unit.downcase!
      begin
        self.base_unit.unit
        errors.add(:base_unit, "Base unit should be a unit of length, weight, volume, or 'each'") unless [:unitless, :length, :mass, :volume].include? self.base_unit.unit.kind
      rescue
        errors.add(:base_unit, "#{base_unit} is not a recognized unit")
      end
    end

    def validate_name
      others = Item.where('name = ? AND id <> ? AND (program_id IS NULL OR program_id = ?)', self.name, self.id, self.program_id)
      errors.add(:name, "Name must be unique within each program") if others.any?
    end

    def strip_units_scalar
      self.base_unit = self.base_unit.unit.units
    end

    private

    def rebase_units
      self.item_purchases.includes(:purchase).order('purchases.date ASC').each do |item|
        item.skip_derivations = true
        item.save
      end
      self.food_inventory_food_items.includes(:food_inventory).order('food_inventories.date ASC').each do |item|
        item.skip_derivations = true
        item.save
      end
    end
  end