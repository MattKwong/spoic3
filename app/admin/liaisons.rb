ActiveAdmin.register Liaison do
  scope :senior_high_only
  scope :junior_high_only
  scope :both
  scope :for_registered_groups

  menu :priority => 3

  show :title => :name do
    panel "Liaison Details" do
      attributes_table_for liaison do
        row("Name") { liaison.name }
        row("Title") { liaison.title }
        row("Liaison to") { liaison.church do |church|
          link_to liaison.church, admin_church_path(church)
        end }
        row("Liaison Type") { liaison.liaison_type}
        row("Address") { liaison.address1 }
        row("Address 2") {liaison.address2 }
        row("City") {liaison.city}
        row("State") {liaison.state }
        row("Zip code") {liaison.zip }
        row("Last update") { :updated_at }
      end
    end

    panel "Registration Information" do
      attributes_table_for liaison do
        row("Name") { liaison.name }
      end
    end

    active_admin_comments
  end

  sidebar "Contact Information", :only => :show do
    attributes_table_for liaison.church do
      row("Primary email") { liaison.email1 }
      row("Second email") { liaison.email2 }
      row("Cell Phone") { liaison.cell_phone }
      row("Work Phone") { liaison.work_phone }
      row("Home Phone") { liaison.home_phone }
      row("Fax") { liaison.fax }
    end
  end

  sidebar "Church Information", :only => :show do
    attributes_table_for liaison.church do
      row("Primary email") { liaison.email1 }
    end
  end

  form do |f|
    f.inputs "Liaison Details" do
      f.input :first_name
      f.input :last_name
      f.input :church
      f.input :title
      f.input :liaison_type
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
#      f.input :updated_at
#      f.input :created_at
    end
    f.buttons
  end

   index do
     column :name do |liaison|
       link_to liaison.name, admin_liaison_path(liaison)
     end
     column :church
     column :liaison_type
     column :city
     column :state
    default_actions
   end
end


