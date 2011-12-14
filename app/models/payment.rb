class Payment < ActiveRecord::Base

  attr_accessible :id, :registration_id, :payment_date, :payment_amount, :payment_method,
                  :payment_notes, :scheduled_group_id
  belongs_to :registration
  belongs_to :scheduled_group

end
