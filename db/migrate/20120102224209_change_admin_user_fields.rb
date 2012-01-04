class ChangeAdminUserFields < ActiveRecord::Migration
  def self.up
    remove_column :admin_users, :role
    add_column :admin_users, :user_role, :string
  end

  def self.down
    add_column :admin_users, :role, :integer
    remove_column :admin_users, :user_role
  end
end
