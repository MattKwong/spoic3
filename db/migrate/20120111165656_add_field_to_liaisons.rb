class AddFieldToLiaisons < ActiveRecord::Migration
  def self.up
    add_column :liaisons, :user_created, :boolean
  end

  def self.down
    remove_column :liaisons, :user_created
  end
end
