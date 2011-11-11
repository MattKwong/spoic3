ActiveAdmin.register PaymentSchedule do
  menu :parent => "Configure Sites and Sessions"

   show do
    attributes_table :name, :total_payment
   end

  index do
    column :name
    column "Total Fee", sortable => :total_payment do |ps|
      number_to_currency ps.total_payment
    end
  end
end
