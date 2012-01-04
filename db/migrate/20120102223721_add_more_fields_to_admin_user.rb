class AddMoreFieldsToAdminUser < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :name, :string
    add_column :admin_users, :first_name, :string
    add_column :admin_users, :last_name, :string
  end

  def self.down
    remove_column :admin_users, :last_name
    remove_column :admin_users, :first_name
    remove_column :admin_users, :name
  end
end
