class Budget < Base
  has_many :budget_items
  has_many :item_purchases
  belongs_to :program

end
