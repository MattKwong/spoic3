class PaymentSchedule < ActiveRecord::Base

  has_many :sessions

  attr_accessible :deposit, :final_payment, :name, :second_payment, :total_payment

  validates :name, :presence => true, :uniqueness => true
  validates :deposit, :final_payment, :second_payment, :total_payment, :presence => true
  validates_numericality_of :deposit, :total_payment, :greater_than => 0
  validates_numericality_of :second_payment, :final_payment, :greater_than_or_equal_to => 0
  validate :total_must_equal_sum_of_payments

  def total_must_equal_sum_of_payments
    if total_payment != deposit + second_payment + final_payment
      errors.add(:final_payment, "must be equal to deposit, second and final payments")
    end
  end
end
