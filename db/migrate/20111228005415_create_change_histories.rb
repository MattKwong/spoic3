class CreateChangeHistories < ActiveRecord::Migration
  def self.up
    create_table :change_histories do |t|
      t.integer :group_id
      t.integer :old_youth
      t.integer :new_youth
      t.integer :old_counselors
      t.integer :new_counselors
      t.integer :old_total
      t.integer :new_total
      t.integer :updated_by

      t.timestamps
    end
  end

  def self.down
    drop_table :change_histories
  end
end
