class MaterialItemEstimated < ActiveRecord::Base

  attr_accessible :item_id, :project_id, :quantity
  belongs_to :project
  belongs_to :item

  validates :item_id, :project_id, :quantity, :presence => true

  def cost(program)
    quantity * Item.find(item_id).average_cost(program, Date.today)
  end
end
