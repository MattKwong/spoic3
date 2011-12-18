class CreateBudgetItems < ActiveRecord::Migration
  def self.up
    create_table :budget_items do |t|
      t.integer :site_id
      t.integer :item_id
      t.decimal :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :budget_items
  end
end
