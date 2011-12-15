ActiveAdmin.register PaymentSchedule do
  menu :parent => "Configuration"

   show show :title => :name do
    attributes_table :name, :deposit, :second_payment, :second_payment_date, :final_payment,
                     :final_payment_date, :total_payment
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
  end
end
