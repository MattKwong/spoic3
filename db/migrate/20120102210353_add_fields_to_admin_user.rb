class AddFieldsToAdminUser < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :role, :string
    add_column :admin_users, :site, :integer
    add_column :admin_users, :admin, :boolean
  end

  def self.down
    remove_column :admin_users, :admin
    remove_column :admin_users, :site
    remove_column :admin_users, :role
  end
end
