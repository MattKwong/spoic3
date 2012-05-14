class CreateProgramsTable < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.integer :id
      t.integer :site_id
      t.integer :program_type_id
      t.boolean :active
      t.string :name
      t.string :short_name
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :programs
  end
end
