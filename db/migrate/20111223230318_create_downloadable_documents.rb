class CreateDownloadableDocuments < ActiveRecord::Migration
  def self.up
    create_table :downloadable_documents do |t|
      t.string :name
      t.string :url
      t.string :description
      t.string :type
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :downloadable_documents
  end
end
