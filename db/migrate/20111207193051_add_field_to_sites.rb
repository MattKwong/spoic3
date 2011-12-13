class AddFieldToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :summer_domestic, :boolean
  end

  def self.down
    remove_column :sites, :summer_domestic
  end
end
