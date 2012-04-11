ActiveAdmin.register Church do
  controller.authorize_resource
  menu :if => proc{ can?(:index, Church) }, :priority => 5

  scope :inactive
  scope :unregistered
  scope :active
  scope :registered, :default => true

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
        row("Is active church?") { church.active }
      end
    end

    panel "Original Request Information" do
      table_for church.registrations do
        column "Group Name", :name
        column "Youth", :requested_youth
        column "Counselors", :requested_counselors
        column "Total", :requested_counselors
        column "Date submitted", :created_at
      end
    end

    panel "Current Schedule Group Information" do
      table_for church.scheduled_groups do
        column "Group Name" do |group|
          link_to group.name, myssp_path(group.liaison_id)
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
    attributes_table_for church do
      row("Church phone") { church.office_phone }
      row("Church fax") { church.fax }
      row("Church email") { mail_to church.email1, church.email1, :subject => "SSP", :body => "Dear " }
    end
  end

  sidebar "Liaisons", :only => :show do
    table_for church.liaisons do
       column :name do |liaison|
         link_to liaison.name, [:admin, liaison]
       end
       column :liaison_type
    end
  end

form :title => :name do |f|
    f.inputs "Church Details" do
      f.input :name
      f.input :address1
      f.input :address2
      f.input :city
      f.input :state, :input_html => { :maxlength => 2, :length => 2 }
      f.input :zip
      f.input :church_type
      f.input :email1
      f.input :office_phone
      f.input :fax
      f.input :active
      f.input :registered
    end
    f.buttons
  end

  index do
    column :name, :sortable => :name do |church|
      link_to church.name, admin_church_path(church)
    end
    column :city
    column :state
    column :zip
    column :church_type_id, :sortable => :church_type_id do |church_type|
      church_type.church_type.name
    end

    column :active
    column :registered
    default_actions
  end
end
