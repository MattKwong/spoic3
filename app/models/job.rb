# == Schema Information
# Schema version:
#
# Table name: jobs
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Job < ActiveRecord::Base
  attr_accessible :name

  has_many :program_users
end