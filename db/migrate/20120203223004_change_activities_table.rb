class ChangeActivitiesTable < ActiveRecord::Migration
  def self.up
    remove_column :activities, :activity_date
    add_column :activities, :activity_date, :datetime
  end

  def self.down
    remove_column :activities, :activity_date
    add_column :activities, :activity_date, :date
  end
end
