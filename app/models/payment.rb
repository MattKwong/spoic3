class Payment < ActiveRecord::Base

  attr_accessible :id, :registration_id, :payment_date, :payment_amount, :payment_method,
                  :payment_notes, :scheduled_group_id, :payment_type
  belongs_to :registration
  belongs_to :scheduled_group

  validates :payment_date, :payment_amount, :payment_method, :presence => true
  validates_numericality_of :payment_amount
  validates_inclusion_of :payment_type, :in => ['Deposit', 'Second', 'Final', 'Other'], :message => "Invalid payment type"

end
