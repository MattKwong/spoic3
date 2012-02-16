class AddNoteToChangeHistory < ActiveRecord::Migration
  def self.up
    add_column :change_histories, :notes, :string
  end

  def self.down
    remove_column :change_histories, :notes
  end
end
