class AddFieldsToChangeHistory < ActiveRecord::Migration
  def self.up
    add_column :change_histories, :old_site, :string
    add_column :change_histories, :new_site, :string
    add_column :change_histories, :old_week, :string
    add_column :change_histories, :new_week, :string
    add_column :change_histories, :old_session, :string
    add_column :change_histories, :new_session, :string
    add_column :change_histories, :site_change, :boolean
    add_column :change_histories, :week_change, :boolean
    add_column :change_histories, :count_change, :boolean
  end

  def self.down
    remove_column :change_histories, :count_change
    remove_column :change_histories, :week_change
    remove_column :change_histories, :site_change
    remove_column :change_histories, :new_session
    remove_column :change_histories, :old_session
    remove_column :change_histories, :new_week
    remove_column :change_histories, :old_week
    remove_column :change_histories, :new_site
    remove_column :change_histories, :old_site
  end
end
