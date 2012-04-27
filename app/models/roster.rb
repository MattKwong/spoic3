class Roster < ActiveRecord::Base
  attr_accessible :id, :group_id, :group_type
    belongs_to :scheduled_group, :foreign_key => :group_id
    has_many :roster_items

    validates :group_id, :group_type, :presence => true

  def name
    unless group_id.nil?
      scheduled_group.name
    end
  end
end
