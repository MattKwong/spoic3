# == Schema Information
# Schema version:
#
# Table name: jobs
#
#  id         :integer         not null, primary key
#  job_type_id         :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Job < ActiveRecord::Base
  attr_accessible :name, :job_type_id

  has_many :program_users
  belongs_to :job_type

end