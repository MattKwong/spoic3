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

  #new do
  #  attributes_table :name, :address1, :address2, :city, :state, :zip, :office_phone,
  #                   :fax, :email1, :active, :registered
  #end

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
