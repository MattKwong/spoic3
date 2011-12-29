class CreateAdjustments < ActiveRecord::Migration
  def self.up
    create_table :adjustments do |t|
      t.integer :group_id
      t.integer :updated_by
      t.decimal :amount
      t.integer :reason_code
      t.string :note

      t.timestamps
    end
  end

  def self.down
    drop_table :adjustments
  end
end
