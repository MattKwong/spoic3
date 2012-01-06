class AddFieldsToPaymentSchedule2 < ActiveRecord::Migration
  def self.up
    add_column :payment_schedules, :second_payment_late_date, :date
    add_column :payment_schedules, :final_payment_late_date, :date
  end

  def self.down
    remove_column :payment_schedules, :final_payment_late_date
    remove_column :payment_schedules, :second_payment_late_date
  end
end
