class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.date :activity_date
      t.string :activity_type
      t.string :activity_details
      t.integer :user_id
      t.integer :user_role
      t.string :user_name

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
