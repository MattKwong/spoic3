class Roster < ActiveRecord::Base
  attr_accessible :id, :group_id, :group_type
    belongs_to :scheduled_group, :foreign_key => :group_id
    has_many :roster_items

    validates :group_id, :group_type, :presence => true

  def name
    unless self.scheduled_group.nil?
      self.scheduled_group.name
    else
      "None"
    end
  end
end
