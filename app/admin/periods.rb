ActiveAdmin.register Period do
  menu :parent => "Configure Sites and Sessions"
#TODO: create current_fiscal_year parameter in new Other_Parameters table
 form do |f|
    f.inputs "Period Details" do
      f.input :name
      f.input :start_date, :start_year => 2011, :required => true
      f.input :end_date, :start_year => 2011, :required => true
    end
    f.buttons
  end
end