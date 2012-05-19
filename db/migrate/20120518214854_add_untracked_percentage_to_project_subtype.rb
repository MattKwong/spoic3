class AddUntrackedPercentageToProjectSubtype < ActiveRecord::Migration
  def self.up
    add_column :project_subtypes, :untracked_percentage, :decimal
  end

  def self.down
    remove_column :project_subtypes, :untracked_percentage
  end
end
