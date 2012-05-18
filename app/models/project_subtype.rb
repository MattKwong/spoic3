class ProjectSubtype < ActiveRecord::Base
  attr_accessible :name, :compound_name, :project_type_id, :untracked_percentage
  has_many :standard_items
  belongs_to :project_type
  before_validation do
    self.compound_name = self.project_type.name + ', ' + self.name
  end

  validates :name, :compound_name, :project_type_id, :presence => true
  validates_numericality_of :untracked_percentage, :greater_than_or_equal_to => 0,
                            :less_than_or_equal_to => 100, :decimal => true,
                            :message => "Must be between 0 and 100."
end
