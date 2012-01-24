ActiveAdmin.register ScheduledGroup do
 menu :priority => 2, :label => "Scheduled Groups", :parent => "Groups"

 show :title => :name do
   panel "Group Details " do
     attributes_table_for scheduled_group do
       row("Group Name") {scheduled_group.name}
       row("Youth") {scheduled_group.current_youth}
       row("Counselors") {scheduled_group.current_counselors}
       row("Total") {scheduled_group.current_total}
       row("Liaison") { scheduled_group.liaison do |liaison|
          link_to scheduled_group.liaison, admin_liaison_path(liaison) end }
       row("Church") { scheduled_group.church do |church|
          link_to scheduled_group.church, admin_church_path(church) end }
       row("Session") { scheduled_group.session do |session|
          link_to scheduled_group.session, admin_session_path(session) end }
       row("Site") { scheduled_group.session.site do |site|
          link_to scheduled_group.session.site, admin_session_path(site) end }
       row("Period") { scheduled_group.session.period do |period|
          link_to scheduled_group.session.period, admin_session_path(period) end }
       row("Start Date") { scheduled_group.session.period.start_date }
       row("End Date") { scheduled_group.session.period.end_date }
       row("2nd Payment Count") { scheduled_group.second_payment_total }
       row("2nd Payment Date") { scheduled_group.second_payment_date }
       #do |d|
       #   d.second_payment_date.strftime("%m/%d/%y") end }
     end
   end
 end

 index do
      column :name, :sortable => :name do |group|
        link_to group.name, myssp_path(group.liaison_id)
      end
      column "Church Name", :church_id do |group| group.church.name end
      column "Youth", :current_youth
      column "Counselors", :current_counselors
      column "Total", :current_total
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
      column "2nd Payment Count", :second_payment_total
      column "2nd Payment Date", :second_payment_date
    default_actions
 end
end
