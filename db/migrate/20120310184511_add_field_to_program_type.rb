class AddFieldToProgramType < ActiveRecord::Migration
  def self.up
    add_column :program_types, :position, :integer
  end

  def self.down
    remove_column :program_types, :position
  end
end
