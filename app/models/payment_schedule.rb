class PaymentSchedule < ActiveRecord::Base
  has_many :sessions
end
