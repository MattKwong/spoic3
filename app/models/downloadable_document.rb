class DownloadableDocument < ActiveRecord::Base
  attr_accessible :name, :url, :description, :doc_type, :active

  validates :name, :url, :description, :doc_type, :active, :presence => true
end
