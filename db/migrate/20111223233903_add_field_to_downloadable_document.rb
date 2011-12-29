class AddFieldToDownloadableDocument < ActiveRecord::Migration
  def self.up
    add_column :downloadable_documents, :doc_type, :string
  end

  def self.down
    remove_column :downloadable_documents, :doc_type
  end
end
