class CreateRosterItems < ActiveRecord::Migration
  def self.up
    create_table :roster_items do |t|
      t.integer :group_id
      t.boolean :youth
      t.boolean :male
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :email
      t.string :shirt_size
      t.string :grade_in_fall

      t.timestamps
    end
  end

  def self.down
    drop_table :roster_items
  end
end
