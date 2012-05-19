class AddSubtypeToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :project_subtype_id, :integer
  end

  def self.down
    remove_column :projects, :project_subtype_id
  end
end
