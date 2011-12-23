class CreateChecklistItems < ActiveRecord::Migration
  def self.up
    create_table :checklist_items do |t|
      t.string :name
      t.date :due_date
      t.string :notes
      t.integer :seq_number
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :checklist_items
  end
end
