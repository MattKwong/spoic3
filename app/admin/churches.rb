ActiveAdmin.register Church do
  menu :priority => 2
  scope :inactive
  scope :unregistered
  scope :active
  scope :registered

  show :title => :name do
    panel "Church Details " do
      attributes_table_for church do
        row("Church Name") {church.name}
        row("Church Type") {church.church_type}
        row("Address") {church.address1}
        row("Address2") {church.address2}
        row("City") {church.city}
        row("State") {church.state}
        row("Zip code") {church.zip}
      end
    end
#TODO: Change this to schedule information when the scheduling function has been written
    panel "Registration Information" do
      attributes_table_for church do
        row("Is active church?") { church.active } #:as => radio
        row("Is registered church?") { church.registered } # :as => radio
      end
      table_for church.registrations do
        column :name
        column "Youth", :requested_youth
        column "Counselors", :requested_counselors

      end
    end

    active_admin_comments
  end

  sidebar "Contact Information", :only => :show do
    attributes_table_for church do
      row("Church phone") { church.office_phone }
      row("Church fax") { church.fax }
      row("Church email") { church.email1 }
    end
  end

  sidebar "Liaisons", :only => :show do
    table_for church.liaisons do
       column :name do |liaison|
         link_to liaison.name, admin_liaison_path(liaison)
       end
       column :liaison_type
    end
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
      f.input :active
      f.input :registered
    end
    f.inputs :name => "Liaisons", :for => :liaison_id do |liaison|
      liaison.input :name
      liaison.input :work_phone
    end
    f.buttons
  end

  index do
    column :name do |church|
      link_to church.name, admin_church_path(church)
    end
    column :city
    column :state
    column :zip
    column :church_type_id do |church_type|
      church_type.church_type.name
    end

    column :active
    column :registered
    default_actions
  end
end
