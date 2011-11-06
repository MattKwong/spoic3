class Payment < ActiveRecord::Base
  attr_accessible :id, :registration_id, :payment_date, :payment_amount, :payment_method, :payment_notes
  belongs_to :registration
end
