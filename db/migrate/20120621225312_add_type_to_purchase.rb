class AddTypeToPurchase < ActiveRecord::Migration
  def self.up
    add_column :purchases, :purchase_type, :string
  end

  def self.down
    remove_column :purchases, :purchase_type
  end
end
