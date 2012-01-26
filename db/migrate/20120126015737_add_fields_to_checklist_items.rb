class AddFieldsToChecklistItems < ActiveRecord::Migration
  def self.up
    add_column :checklist_items, :active, :boolean
    add_column :checklist_items, :default_status, :string
  end

  def self.down
    remove_column :checklist_items, :default_status
    remove_column :checklist_items, :active
  end
end
