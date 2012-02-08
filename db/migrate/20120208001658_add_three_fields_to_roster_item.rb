class AddThreeFieldsToRosterItem < ActiveRecord::Migration
  def self.up
    add_column :roster_items, :disclosure_status, :string
    add_column :roster_items, :covenant_status, :string
    add_column :roster_items, :background_status, :string
  end

  def self.down
    remove_column :roster_items, :background_status
    remove_column :roster_items, :covenant_status
    remove_column :roster_items, :disclosure_status
  end
end
