ActiveAdmin.register Liaison do
  scope :senior_high_only
  scope :junior_high_only
  scope :both
  scope :for_registered_groups

  menu :priority => 3

  form do |f|
    f.inputs "Edit" do
      f.input :last_name
      f.input :first_name
      f.input :title
      f.input :address1
      f.input :address2
      f.input :city
      f.input :state
      f.input :zip
      f.input :email1
      f.input :email2
      f.input :cell_phone
      f.input :work_phone
      f.input :home_phone
      f.input :fax
      f.input :updated_at
      f.input :created_at
    end
    f.buttons
  end

  form do |f|
    f.inputs "Get" do
      f.input :name
      f.input :church
      f.input :title
      f.input :address1
      f.input :address2
      f.input :city
      f.input :state
      f.input :zip
      f.input :email1
      f.input :email2
      f.input :cell_phone
      f.input :work_phone
      f.input :home_phone
      f.input :fax
      f.input :updated_at
      f.input :created_at
    end
    f.buttons
  end

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
