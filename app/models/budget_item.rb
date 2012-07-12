class BudgetItem < ActiveRecord::Base
  belongs_to :budget_item_type
  belongs_to :program
  attr_accessible :amount, :budget_item_type_id, :program_id

  validates :budget_item_type_id, :amount, :presence => true
  validates_numericality_of :amount, :greater_than_or_equal_to => 0, :decimal => true

#  validate :program_and_item_unique

  validate :program_valid
  validate :item_valid

#  get all budget items with budget type of food.
  scope :food, lambda {joins(:budget_item_type).where("budget_item_types.name = 'Food'" ) }
  scope :materials, lambda {joins(:budget_item_type).where("budget_item_types.name = 'Materials'" ) }
  scope :tools, lambda {joins(:budget_item_type).where("budget_item_types.name = 'Tools'" ) }
  scope :gas, lambda {joins(:budget_item_type).where("budget_item_types.name = 'Gas'" ) }
  scope :other, lambda {joins(:budget_item_type).where("budget_item_types.name = 'Other'" ) }
  scope :for_program, lambda { |program| where(:program_id => program.id) }
  scope :alphabetized, :order => :budget_item_type_id
  def budget_item_food
    BudgetItemType.find(self.budget_item_type_id).name == "Food"
  end

  def program_valid
    errors.add(:site_id, "Must enter a valid site.") unless Program.find(program_id)
  end

  def item_valid
    errors.add(:item_id, "Must enter a valid item type.") unless BudgetItemType.find(budget_item_type_id)
  end

  def program_and_item_unique
    if BudgetItem.find_by_budget_item_type_id_and_program_id(:budget_item_type_id, :program_id) then
      errors.add(:program_id, "A budget item already exists for this program and item type.")
    end
  end
end
