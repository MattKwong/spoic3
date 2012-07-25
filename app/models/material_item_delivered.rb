class MaterialItemDelivered < ActiveRecord::Base

  attr_accessible :item_id, :project_id, :quantity, :delivery_date, :delivered_by
  belongs_to :project
  belongs_to :item
  belongs_to :admin_user, :foreign_key => :delivered_by

  scope :for_program, lambda { |program| includes(:project).where('projects.program_id = ?', program.id) }
  scope :for_item_program, lambda { |item_id, program_id| includes(:project).where('projects.program_id = ? and item_id = ?', program_id, item_id) }
  scope :alphabetized, :include => :item, :order => 'items.name'
  validates :item_id, :project_id, :quantity, :delivered_by, :presence => true
  validates_numericality_of :quantity, :decimal => true
  validate :quantity_cannot_be_zero, :quantity_cannot_be_greater_than_on_hand
  validate :returned_cannot_be_greater_than_net_delivered, :if => :return?

  def quantity_cannot_be_zero
    if quantity == 0
      errors.add(:quantity, "can't be equal to zero")
    end
  end

  def quantity_cannot_be_greater_than_on_hand
    program = Project.find(self.project_id).program
    if quantity > total_on_hand(program)
      errors.add(:quantity, "Exceeds the amount on hand")
    end
  end

  def returned_cannot_be_greater_than_net_delivered

    if quantity.abs > net_delivered(project_id)
      errors.add(:quantity, "Only #{net_delivered(project_id)} of this item has been delivered to this project.")
    end
  end

  def return?
    quantity < 0
  end

  def net_delivered(item, project)
    total = 0
    MaterialItemDelivered.find_all_by_item_id_and_project_id(item, project).each {|m| total += m.quantity}
    total
  end

  def cost(program)
    quantity * Item.find(item_id).average_cost(program, Date.today)
  end

  def total_on_hand(program)
    item.construction_onhand(program)
  end

end
