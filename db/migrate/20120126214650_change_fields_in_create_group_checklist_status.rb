class ChangeFieldsInCreateGroupChecklistStatus < ActiveRecord::Migration
  def self.up
    remove_column :group_checklist_statuses, :checklist_item_id
    remove_column :group_checklist_statuses, :group_id
    add_column :group_checklist_statuses, :checklist_item_id, :integer
    add_column :group_checklist_statuses, :group_id, :integer
  end

  def self.down
    remove_column :group_checklist_statuses, :checklist_item_id
    remove_column :group_checklist_statuses, :group_id
    add_column :group_checklist_statuses, :checklist_item_id, :string
    add_column :group_checklist_statuses, :group_id, :string
  end
end
