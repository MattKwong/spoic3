class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.string :name
      t.integer :seq_number
      t.string :first_line
      t.string :second_line
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :reminders
  end
end
