ActiveAdmin.register PaymentSchedule do
  menu :parent => "Configure Sites and Sessions"

   show do
    attributes_table :name, :deposit, :second_payment, :final_payment, :total_payment
   end

  index do
    column :name
    column :deposit
    column :second_payment
#    column "Second Payment Date"
    column :final_payment
#    column "Final Payment Date"
    column "Total Fee" do |ps|
      number_to_currency ps.total_payment
    end
  end
end
