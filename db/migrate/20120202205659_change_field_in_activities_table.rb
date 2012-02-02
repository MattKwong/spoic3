class ChangeFieldInActivitiesTable < ActiveRecord::Migration
  def self.up
    remove_column :activities, :user_role
    add_column :activities, :user_role, :string

  end

  def self.down
    remove_column :activities, :user_role
    add_column :activities, :user_role, :integer
  end
end
