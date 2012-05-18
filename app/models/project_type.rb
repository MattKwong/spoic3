class ProjectType < ActiveRecord::Base
  attr_accessible :name, :description, :project_category_id
  belongs_to :project_category
  has_many :projects_subtypes
  validates :name, :project_category_id, :presence => true

end
