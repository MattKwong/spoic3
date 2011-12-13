class AddFieldToPeriods < ActiveRecord::Migration
  def self.up
    add_column :periods, :summer_domestic, :boolean
  end

  def self.down
    remove_column :periods, :summer_domestic
  end
end
