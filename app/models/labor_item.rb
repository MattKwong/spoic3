class LaborItem < ActiveRecord::Base
  attr_accessible :project_id, :session_id, :recorded_by, :team_name, :team_size, :days_worked
  belongs_to :project
  belongs_to :session
  belongs_to :admin_user, :foreign_key => :recorded_by

  validates :project_id, :session_id, :recorded_by, :team_name, :team_size, :days_worked, :presence => true
  validates_numericality_of :days_worked, :greater_than_or_equal_to => 0.5, :less_than_or_equal_to => 5
  validates_numericality_of :team_size, :greater_than => 0, :less_than_or_equal_to => 15
  after_save :update_project

  def update_project
    project.update_change_date
  end

  def actual_days
    team_size * days_worked
  end

end
