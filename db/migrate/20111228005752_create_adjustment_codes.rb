class CreateAdjustmentCodes < ActiveRecord::Migration
  def self.up
    create_table :adjustment_codes do |t|
      t.string :short_name
      t.string :long_name

      t.timestamps
    end
  end

  def self.down
    drop_table :adjustment_codes
  end
end
