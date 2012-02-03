ActiveAdmin.register PaymentSchedule do
  controller.authorize_resource
  menu :if => proc{ can?(:read, PaymentSchedule) }, :parent => "Configuration"

   show show :title => :name do
    attributes_table :name, :deposit, :second_payment, :second_payment_date, :final_payment,
                     :final_payment_date, :total_payment, :second_payment_late_date,
                      :final_payment_late_date
   end

  index do
    column :name
    column :deposit
    column "Second Payment" do |a|
      number_to_currency a.second_payment
    end
    column :second_payment_date
    column "Final Payment" do |a|
      number_to_currency a.final_payment
    end
    column :final_payment_date
    column "Total Fee" do |a|
      number_to_currency a.total_payment
    end
    column "2nd Payment Late Date", :second_payment_late_date
    column "Final Payment Late Date", :final_payment_late_date
    default_actions
  end
end
