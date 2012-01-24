class AddConfirmableToAdminUsers < ActiveRecord::Migration
  def self.up
     add_column :admin_users, :confirmation_token, :string
     add_column :admin_users, :confirmed_at, :datetime
     add_column :admin_users, :confirmation_sent_at, :datetime
  end

  def self.down
    remove_column :admin_users, :confirmation_token
    remove_column :admin_users, :confirmed_at
    remove_column :admin_users, :confirmation_sent_at
  end
end
