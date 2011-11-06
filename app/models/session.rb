class Session < ActiveRecord::Base

  belongs_to :site
  belongs_to :period
  belongs_to :session_type
  belongs_to :payment_schedule

  attr_accessible :name, :period_id, :site_id, :payment_schedule_id, :session_type_id
end
