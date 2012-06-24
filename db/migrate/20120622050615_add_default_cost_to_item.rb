class AddDefaultCostToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :default_cost, :decimal
  end

  def self.down
    remove_column :items, :default_cost
  end
end
