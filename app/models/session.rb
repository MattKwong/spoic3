class Session < ActiveRecord::Base

  belongs_to :site
  belongs_to :period
  belongs_to :session_type
  belongs_to :payment_schedule
  belongs_to :program
  has_many :scheduled_groups
  accepts_nested_attributes_for :scheduled_groups

  attr_accessible :name, :period_id, :site_id, :payment_schedule_id, :session_type_id, :program_id

  def scheduled_adults
    (self.scheduled_groups.map &:current_counselors).sum
  end

  def scheduled_youth
    (self.scheduled_groups.map &:current_youth).sum
  end

  def scheduled_total
    scheduled_adults + scheduled_youth
  end

end
