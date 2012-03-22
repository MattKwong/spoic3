# == Schema Information
# Schema version:
#
# Table name: program_users
#
#  id         :integer         not null, primary key
#  program_id :integer
#  user_id    :integer
#  job_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProgramUser < ActiveRecord::Base
  attr_accessible :user_id, :program_id, :job_id

  validates :user_id, :presence => true
  validates :job_id, :presence => true
  validates :program_id, :presence => true

  belongs_to :admin_user, :foreign_key => :user_id
  belongs_to :program
  belongs_to :job

  def job_name
    self.job.name
  end

end