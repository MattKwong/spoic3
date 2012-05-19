class AddUntrackedToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :untracked, :boolean
  end

  def self.down
    remove_column :items, :untracked
  end
end
