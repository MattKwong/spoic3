class ScheduledGroupsController < ApplicationController
  require 'erb'

  def program_session
    @groups = ScheduledGroup.find_all_by_session_id(params[:id])
    session = Session.find(params[:id])
    @session_week = Period.find(session.period.id).name
    @session_site = Site.find(session.site_id).name
  end

  def confirmation       # before the confirmation screen
    @title = "Group Confirmation"
    @registration = Registration.find(params[:reg])
    logger.debug ScheduledGroup.find_all_by_registration_id(params[:reg]).inspect
    if ScheduledGroup.find_all_by_registration_id(params[:reg]).count == 0
      @scheduled_group = ScheduledGroup.new(:church_id => @registration.church_id,
                        :name => @registration.name, :registration_id => @registration.id,
                        :current_youth => @registration.requested_youth,
                        :current_counselors => @registration.requested_counselors,
                        :current_total => @registration.requested_total,
                        :liaison_id => @registration.liaison_id, :session_id => params[:id],
                        :scheduled_priority => params[:priority])
    else if ScheduledGroup.find_all_by_registration_id(params[:reg]).count == 1
      @scheduled_group = ScheduledGroup.find_by_registration_id(params[:reg])
         else
          flash[:error] = "Duplicate schedules exist for this registration. Contact support."
         end
    end
    @scheduled_group.save!
    @session = Session.find(params[:id])
  end

  def update

    if params[:commit] == 'Cancel'
#      logger.debug "Groups Controller cancel: #{params.inspect}"
      ScheduledGroup.delete(params[:id])
      redirect_to admin_registrations_path
    else if params[:commit] == "Back"
      redirect_to scheduled_groups_schedule_path(params[:id])
         else
           current_reg = Registration.find(ScheduledGroup.find(params[:id]).registration_id)
           current_reg.scheduled = true
           if current_reg.update_attributes(current_reg)
              redirect_to scheduled_group_confirmation_path(params[:id])
           else
              flash[:error] = "Update of registration record failed. Contact support."
           end
         end
    end
  end

  def success
    require 'erb'
    @title = "Scheduling Complete"
    @scheduled_group = ScheduledGroup.find(params[:id])
    @session = Session.find(@scheduled_group.session_id)
    filename = File.join('app', 'views', 'email_templates', 'schedule_confirmation.text.erb')
    f = File.open(filename)
    body = f.read.gsub(/^  /, '')
    @site = Site.find(@session.site_id).name
    period = Period.find(@session.period_id)
    liaison = Liaison.find(@scheduled_group.liaison_id)
    @current_date = Time.now.strftime("%a, %b %d, %Y")
    @first_name = liaison.first_name
    @week = period.name
    @start_date = period.start_date.strftime("%a, %b %d, %Y")
    @end_date = period.end_date.strftime("%a, %b %d, %Y")
    @group_name = @scheduled_group.name
    @church_name = Church.find(@scheduled_group.church_id).name
    @liaison_name = liaison.name
    @current_youth = @scheduled_group.current_youth
    @current_counselors = @scheduled_group.current_counselors
    @current_counselors = @scheduled_group.current_total

    message = ERB.new(body, 0, "%<>")
    @email_body = message.result(binding)

  end
end
