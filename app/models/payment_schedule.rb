class PaymentSchedule < ActiveRecord::Base

  has_many :sessions

  attr_accessible :deposit, :final_payment, :name, :second_payment, :second_payment_date,
                 :total_payment, :final_payment_date, :second_payment_late_date, :final_payment_late_date

  validates :name, :presence => true, :uniqueness => true
  validates :deposit, :final_payment, :second_payment, :total_payment, :presence => true
  validates_numericality_of :deposit, :total_payment, :greater_than => 0
  validates_numericality_of :second_payment, :final_payment, :greater_than_or_equal_to => 0
  validates_date :second_payment_date, :final_payment_date, :second_payment_late_date,
                 :final_payment_late_date, :allow_nil => true
  validate :second_payment_date_before_final
  validate :total_must_equal_sum_of_payments

  def total_must_equal_sum_of_payments
    if total_payment != deposit + second_payment + final_payment
      errors.add(:final_payment, "must be equal to deposit, second and final payments")
    end
  end

  def second_payment_date_before_final
    unless second_payment_date.nil? || final_payment_date.nil?
      if second_payment_date >= final_payment_date
        errors.add(:second_payment_date, "must be prior or equal to the final payment date")
      end
    end
  end
end
