ActiveAdmin.register RosterItem do
  controller.authorize_resource
  menu :if => proc{ can?(:read, RosterItem) }, :parent => "Groups"
  show :title => :last_name

  scope :all
  scope :youth
  scope :adults, :default => true

  filter :roster_id, :label => 'Group Name', :as => :select, :collection => proc {(ScheduledGroup.all.map {|group| group.name}).sort }
  filter :city
  filter :state
  filter :last_name
  filter :disclosure_status, :as => :check_boxes, :collection => ['Received', 'Incomplete', 'Not Received']
  filter :background_status, :as => :check_boxes, :collection => ['Church Verified', 'Online Verified', 'Not Received']
  filter :covenant_status, :as => :check_boxes, :collection => ['Received', 'Incomplete', 'Not Received']

  index do
    column "Last Name", :last_name
    column "First Name", :first_name
    column "Group Name", :roster_id do |item|
      link_to item.group_name, myssp_path(item.roster.scheduled_group.liaison_id)
    end
    column "Site", :roster_id do |item| item.roster.scheduled_group.session.site.name end
    column "Week", :roster_id do |item| item.roster.scheduled_group.session.period.name end
    column "Church Name", :roster_id do |item| item.roster.scheduled_group.church.name end
    column "Disclosure Status", :disclosure_status
    column "Gender",  :gender, :sortable => :male
    column "Youth/Counselor", :youth_or_counselor, :sortable => :youth
    column "Special Needs", :special_need
    default_actions
  end
end