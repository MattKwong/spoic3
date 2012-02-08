class ChangeSiteFieldInAdminUser < ActiveRecord::Migration
  def self.up
    remove_column :admin_users, :site
    add_column :admin_users, :site_id, :integer
  end

  def self.down
    remove_column :admin_users, :site_id
    add_column :admin_users, :site, :integer
  end
end
