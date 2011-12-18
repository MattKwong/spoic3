class CreateBudgetItemTypes < ActiveRecord::Migration
  def self.up
    create_table :budget_item_types do |t|
      t.string :name
      t.string :description
      t.integer :seq_number

      t.timestamps
    end
  end

  def self.down
    drop_table :budget_item_types
  end
end
