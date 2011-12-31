ActiveAdmin.register Liaison do

  scope :senior_high_only
  scope :junior_high_only
  scope :both

  menu :priority => 5

  show :title => :name do
    panel "Liaison Details" do
      attributes_table_for liaison do
        row("Name") { liaison.name }
        row("Title") { liaison.title }
        row("Liaison to") { liaison.church do |church|
          link_to liaison.church, [:admin, church]
        end }
        row("Liaison Type") { liaison.liaison_type}
        row("Address") { liaison.address1 }
        row("Address 2") {liaison.address2 }
        row("City") {liaison.city}
        row("State") {liaison.state }
        row("Zip code") {liaison.zip }
        row("Last update") { liaison.updated_at }
      end
    end

    panel "Original Request Information" do
      table_for liaison.registrations do
        column "Group Name", :name
        column "Youth", :requested_youth
        column "Counselors", :requested_counselors
        column "Total", :requested_counselors
        column "Date submitted", :created_at
      end
    end

    panel "Current Schedule Group Information" do
      table_for liaison.scheduled_groups do
        column "Group Name" do |group|
          link_to group.name, myssp_path(group.liaison_id),
          :title => 'Click to go to MySSP page for this liaison.'
        end
        column "Youth", :current_youth
        column "Counselors", :current_counselors
        column "Total", :current_total
        column "Session", :session_id do |session|
          link_to session.session.name, sched_program_session_path(session.session.id)
        end
        column "Site", :session_id do |session|
          session.session.site.name
        end
        column "Period", :session_id do |session|
          session.session.period.name
        end
        column "Start", :session_id do |period|
          period.session.period.start_date.strftime("%m/%d/%y")
        end
        column "End", :session_id do |session|
          session.session.period.end_date.strftime("%m/%d/%y")
        end
      end
    end
    active_admin_comments
  end

  sidebar "Contact Information", :only => :show do
    attributes_table_for liaison.church do
      row("Primary email") { mail_to liaison.email1, liaison.email1, :subject => "SSP", :body => "Dear " }
      row("Second email") { mail_to liaison.email2, liaison.email2, :subject => "SSP", :body => "Dear " }
      row("Cell Phone") { liaison.cell_phone }
      row("Work Phone") { liaison.work_phone }
      row("Home Phone") { liaison.home_phone }
      row("Fax") { liaison.fax }
    end
  end

  sidebar "Church Information", :only => :show do
    attributes_table_for liaison.church do
      row("Primary email") { mail_to liaison.church.email1, liaison.church.email1,
      :subject => "SSP", :body => "Dear " }
    end
  end

  form do |f|
    f.inputs "Liaison Details" do
      f.input :first_name
      f.input :last_name
      f.input :church, :include_blank => false, :order => :name
      f.input :title, :hint => "Enter the person's title"
      f.input :liaison_type, :include_blank => false
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
     column :name, :sortable => :last_name do |liaison|
       link_to liaison.name, admin_liaison_path(liaison)
     end
     column :church_id, :sortable => :name do |church|
       link_to church.church.name, admin_church_path(church.church_id)
     end

     column :liaison_type, :sortable => :liaison_type_id
     column :city, :sortable => :city
     column :state, :sortable => :state
     default_actions
   end
end


