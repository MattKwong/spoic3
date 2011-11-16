class Registration < ActiveRecord::Base
  attr_accessible :name,:comments, :current_counselors, :current_youth,
                  :current_total, :liaison_id, :request1, :request2, :request3,
                  :request4, :request5, :request6,:request7, :request8, :request9,
                  :request10, :requested_counselors, :requested_youth,
                  :requested_total, :scheduled, :scheduled_priority,
                  :scheduled_session, :amount_due, :amount_paid, :payment_method,
                  :payment_notes, :group_type_id
  has_many :payments

  validates :name, :requested_youth, :requested_counselors, :request1, :presence => true
  validates_numericality_of :requested_youth, :requested_counselors, :only_integer => true, :greater_than => 0
  validates_numericality_of :request1

  validate :request_sequence

  def request_sequence

  end


end
