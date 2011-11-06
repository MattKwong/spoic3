ActiveAdmin.register Liaison do
  scope :senior_high_only
  scope :junior_high_only
  scope :both
  scope :for_registered_groups

  menu :priority => 3

   index do
     column :name
     column :liaison_type
     column :city
     column :state
     column :church
     column :home_phone
     column :cell_phone
     column :work_phone
     column :fax
     column :email1
     default_actions
   end

end
