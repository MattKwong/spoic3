class ProjectCategory < ActiveRecord::Base
  has_many :project_types
  attr_accessible :name, :description
  validates :name, :description, :presence => true
end
