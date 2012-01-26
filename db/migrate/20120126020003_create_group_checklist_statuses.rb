class CreateGroupChecklistStatuses < ActiveRecord::Migration
  def self.up
    create_table :group_checklist_statuses do |t|
      t.string :group_id
      t.string :checklist_item_id
      t.string :status
      t.string :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :group_checklist_statuses
  end
end
