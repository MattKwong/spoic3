ActiveAdmin.register Church do
  menu :priority => 2
  scope :inactive
  scope :unregistered
  scope :active
  scope :registered

  show do
    attributes_table :name, :address1, :address2, :city, :state, :zip, :office_phone,
                     :fax, :email1, :active, :registered
  end

form do |f|
    f.inputs "Church Details" do
      f.input :name
      f.input :address1
      f.input :address2
      f.input :city
      f.input :state
      f.input :zip
      f.input :email1
      f.input :office_phone
      f.input :fax
      f.input :updated_at
      f.input :created_at
      f.input :liaison_id
      f.input :active
      f.input :registered
    end
    f.buttons
  end

  index do
    column :name
    #column :address1
    #column :address2
    column :city
    column :state
    column :zip
    column :office_phone
    column :fax
    column :email1
    #column :church_type_id
    column :active
    column :registered
    default_actions
  end
end
