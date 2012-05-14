class CreateProgramUsers < ActiveRecord::Migration
  def self.up
    create_table :program_users do |t|
      t.integer :id
      t.integer :job_id
      t.integer :program_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :program_users
  end
end
