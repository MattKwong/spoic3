class Roster < ActiveRecord::Base
  attr_accessible :id, :group_id, :group_type
    belongs_to :scheduled_group
    has_many :roster_items

    validates :group_id, :group_type, :presence => true
end
