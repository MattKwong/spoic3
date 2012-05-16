class ProjectSubtype < ActiveRecord::Base
  attr_accessible :name, :compound_name, :project_type_id
  has_many :standard_items
  belongs_to :project_type
  before_validation do
    self.compound_name = self.project_type.name + ', ' + self.name
  end

  validates :name, :compound_name, :project_type_id, :presence => true
end
