class MaterialItemEstimated < ActiveRecord::Base

  attr_accessible :item_id, :project_id, :quantity
  belongs_to :project
  belongs_to :item

  validates :item_id, :project_id, :quantity, :presence => true
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0.1
  after_save :update_project

  def update_project
    project.update_change_date
  end


  def cost(program)
    quantity * Item.find(item_id).average_cost(program, Date.today)
  end

end
