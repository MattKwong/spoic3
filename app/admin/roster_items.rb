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

  csv do
      column :last_name
      column :first_name
      column :email
      column :address1
      column :address2
      column :city
      column :state
      column :zip
      column :shirt_size
      column :grade_in_fall
      column :gender
      column :youth_or_counselor
      column("Group Name") { |item| item.group_name }
      column("Site") { |item| item.roster.scheduled_group.session.site.name }
      column("Week"){ |item| item.roster.scheduled_group.session.period.name }
      column("Church Name") { |item| item.roster.scheduled_group.church.name }
      column :disclosure_status
      column :covenant_status
      column :background_status
      column :special_need
      column("Date Created") { |item| item.created_at.localtime }
      column("Last Updated") { |item| item.updated_at.localtime }
  end
end