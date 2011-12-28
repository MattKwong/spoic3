class RosterController < ApplicationController
  def show
    roster = Roster.find(params[:roster_id])
    scheduled_group = ScheduledGroup.find(roster.group_id)
    liaison_name = Liaison.find(scheduled_group.liaison_id).name
    items = RosterItem.find_all_by_roster_id(roster.id)
    site_name = Site.find(Session.find(scheduled_group.session_id).site_id).name
    period_name = Period.find(Session.find(scheduled_group.session_id).period_id).name
    start_date = Period.find(Session.find(scheduled_group.session_id).period_id).start_date
    end_date = Period.find(Session.find(scheduled_group.session_id).period_id).end_date
    session_type = SessionType.find(Session.find(scheduled_group.session_id).session_type_id).name
    if items.nil? || items.count == 0
        roster_status = 'Not started'
        left_to_enter = scheduled_group.current_total
    else
      left_to_enter = scheduled_group.current_total - items.count
      if items.count < scheduled_group.current_total
        roster_status = "Started"
      else if items.count == scheduled_group.current_total
        roster_status = "Completed"
           else
            roster_status = "Needs attention"
           end
        end
    end
    @roster_info = {:roster => roster, :scheduled_group => scheduled_group, :items => items,
      :site_name => site_name, :period_name => period_name, :start_date => start_date,
      :end_date => end_date,  :session_type => session_type, :roster_status => roster_status,
      :left_to_enter => left_to_enter, :liaison_name => liaison_name}
    @title = "Roster for: #{scheduled_group.name}"
  end
end
