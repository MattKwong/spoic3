class BudgetItem < ActiveRecord::Base
  belongs_to :budget_item_type, :foreign_key => :item_id
  belongs_to :site
  attr_accessible :amount, :item_id, :site_id

  validates :item_id, :amount, :site_id, :presence => true
  validates_numericality_of :amount, :greater_than_or_equal_to => 0, :decimal => true

  validate :site_valid
  validate :item_valid
  validate :site_and_item_unique

  def site_valid
    errors.add(:site_id, "Must enter a valid site.") unless Site.find(site_id)
  end
  def item_valid
    errors.add(:item_id, "Must enter a valid item type.") unless BudgetItemType.find(item_id)
  end

  def site_and_item_unique
    if Proc.new {BudgetItem.find(:conditions => ["item_id = ? AND site_id = ?", a.item_id, a.site_id])} then
      errors.add(:site_id, "A budget line item already exists for this site and item.")
    end
  end
end
