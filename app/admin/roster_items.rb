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
      column :male
      column :youth
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

form :title => :name do |f|
    f.inputs "Roster item Details" do
      f.input :last_name
      f.input :first_name
      f.input :email
      f.input :address1
      f.input :address2
      f.input :city
      f.input :state, :input_html => { :maxlength => 2, :length => 2 }
      f.input :zip
      f.input :shirt_size, :as => :select, :collection => ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'], :include_blank => false
      f.input :youth, :as => :select, :collection => ['7th', '8th', '9th', '10th', '11th', '12th', '13th', 'Adult', 'Other'], :include_blank => false
      f.input :male, :as => :select, :collection => [["Male", true], ["Female", false]], :include_blank => false, :label => "Gender"
      f.input :youth, :as => :select, :collection => [["Youth", true], ["Counselor", false]], :include_blank => false, :label => "Youth or Counselor"
      f.input :special_need, :as => :select, :collection => SpecialNeed.all
      f.input :disclosure_status, :as => :select, :collection => ['Received', 'Incomplete', 'Not Received'], :include_blank => false
      f.input :covenant_status, :as => :select, :collection => ['Received', 'Incomplete', 'Not Received'], :include_blank => false
      f.input :background_status, :as => :select, :collection => ['Church Verified', 'Online Verified', 'Not Received'], :include_blank => false
    end
    f.buttons
  end
end