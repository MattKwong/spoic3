class AddAbbrToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :abbr, :string
  end

  def self.down
    remove_column :sites, :abbr
  end
end
