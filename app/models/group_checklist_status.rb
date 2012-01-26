class GroupChecklistStatus < ActiveRecord::Base
    attr_accessible :checklist_item_id, :group_id, :status, :notes

  validates :checklist_item_id, :group_id, :status, :presence => true
end
