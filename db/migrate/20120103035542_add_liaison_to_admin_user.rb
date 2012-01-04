class AddLiaisonToAdminUser < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :liaison_id, :integer
  end

  def self.down
    remove_column :admin_users, :liaison_id
  end
end
