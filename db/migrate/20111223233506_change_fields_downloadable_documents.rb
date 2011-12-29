class ChangeFieldsDownloadableDocuments < ActiveRecord::Migration
  def self.up
    remove_column :downloadable_documents, :type
  end

  def self.down
    add_column :downloadable_documents, :type, :string
  end
end
