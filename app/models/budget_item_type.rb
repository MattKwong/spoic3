class BudgetItemType < ActiveRecord::Base
  has_many :budget_items

  attr_accessible :description, :name, :seq_number

  validates :name, :presence => true, :uniqueness => true
  validates :description, :seq_number, :presence => true
  validates_numericality_of :seq_number, :greater_than_or_equal_to => 0, :integer => true

  def food?
    self.name == "Food"
  end
end
