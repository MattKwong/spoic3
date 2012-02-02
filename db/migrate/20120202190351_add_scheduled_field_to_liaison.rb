class AddScheduledFieldToLiaison < ActiveRecord::Migration
  def self.up
    add_column :liaisons, :scheduled, :boolean
    add_column :liaisons, :registered, :boolean
  end

  def self.down
    remove_column :liaisons, :registered
    remove_column :liaisons, :scheduled
  end
end
