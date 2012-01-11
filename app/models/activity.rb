class Activity < ActiveRecord::Base
  attr_accessible :id, :activity_date, :activity_details, :activity_type, :user_id, :user_name, :user_role

  validates  :activity_date, :activity_details, :activity_type, :user_id, :user_name, :user_role, :presence => true
  validates_numericality_of :user_id

end
