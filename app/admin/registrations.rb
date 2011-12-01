ActiveAdmin.register Registration do
  menu :priority => 2, :label => "Requests"
  scope :scheduled
  scope :unscheduled
 index do
    column :name do |r|
      link_to r.name, schedule_request_path(:id => r.id)
    end

    column :liaison_id do |liaison|
      link_to liaison.liaison.name, admin_liaison_path(liaison.liaison_id)
    end
    column :church_id do |church|
      link_to church.church.name, admin_church_path(church.church_id)
    end

    column :requested_youth, :label => "Youth"
    column :requested_counselors, :label => "Counselors"
    column :requested_total, :label => "Total"
    column :scheduled
    column :registration_step
    default_actions
 end


end
