class AddPhoneToAdminUser < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :phone, :string
  end

  def self.down
    remove_column :admin_users, :phone
  end
end
