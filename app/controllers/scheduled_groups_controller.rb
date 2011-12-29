class ScheduledGroupsController < ApplicationController
  require 'erb'
    before_filter :check_for_cancel, :only => [:update]
    before_filter :check_for_submit_changes, :only => [:update]

  def program_session
    @groups = ScheduledGroup.find_all_by_session_id(params[:id])
    session = Session.find(params[:id])
    @session_week = Period.find(session.period.id).name
    @session_site = Site.find(session.site_id).name
  end

  def confirmation       # before the confirmation screen
    @title = "Group Confirmation"
    @registration = Registration.find(params[:reg])
    if ScheduledGroup.find_all_by_registration_id(params[:reg]).count == 0
      @scheduled_group = ScheduledGroup.new(:church_id => @registration.church_id,
                        :name => @registration.name, :registration_id => @registration.id,
                        :current_youth => @registration.requested_youth,
                        :current_counselors => @registration.requested_counselors,
                        :current_total => @registration.requested_total,
                        :liaison_id => @registration.liaison_id, :session_id => params[:id],
                        :group_type_id => @registration.group_type_id,
                        :scheduled_priority => params[:priority])
    else if ScheduledGroup.find_all_by_registration_id(params[:reg]).count == 1
      @scheduled_group = ScheduledGroup.find_by_registration_id(params[:reg])
         else
          flash[:error] = "Duplicate schedules exist for this registration. Contact support."
         end
    end
    @scheduled_group.save!
    roster = Roster.create!(:group_id => @scheduled_group.id,
      :group_type => SessionType.find(Session.find(@scheduled_group.session_id).session_type_id).id)
    @scheduled_group.update_attribute('roster_id', roster.id)
    @session = Session.find(params[:id])
  end

  def update
    ## The final scheduling step is to set the scheduled flag on the registered record
    ## and to update the scheduled id in the payment records
    current_reg = Registration.find(ScheduledGroup.find(params[:id]).registration_id)
    current_reg.scheduled = true
    if current_reg.update_attributes(current_reg)
      redirect_to scheduled_group_confirmation_path(params[:id])
    else
      flash[:error] = "Update of registration record failed for unknown reason."
    end

    payments = Payment.find_all_by_registration_id(current_reg.id)
    payments.each do |p|
      p.update_attribute('scheduled_group_id', params[:id])
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

  def edit
    @scheduled_group = ScheduledGroup.find(params[:id])
    @session = Session.find(@scheduled_group.session_id)
    @sessions = Session.find_all_by_session_type_id(@scheduled_group.group_type_id).map { |s| [s.name, s.id ]}
    @title = "Change Schedule"
  end

  def check_for_cancel
    if params[:commit] == 'Cancel'
      ScheduledGroup.delete(params[:id])
      redirect_to admin_registrations_path
     end
  end

  def check_for_submit_changes
    if params[:commit] == 'Submit Changes'
      group_id = params[:id]
      group = ScheduledGroup.find(group_id)
      new_values = params[:scheduled_group]
      new_session_name = Session.find(new_values[:session_id]).name
      old_session_name = Session.find(group.session_id).name
      new_week_name = Period.find(Session.find(new_values[:session_id]).period_id).name
      old_week_name = Period.find(Session.find(group.session_id).period_id).name
      new_site_name = Site.find(Session.find(new_values[:session_id]).site_id).name
      old_site_name = Site.find(Session.find(group.session_id).site_id).name
      site_change = week_change = count_change = true
      if new_week_name == old_week_name then week_change = false end
      if new_site_name == old_site_name then site_change = false end
      if (new_values[:current_youth] == group.current_youth) && (new_values[:current_youth] == group.current_youth) then
        count_change = false
      end
            logger.debug new_values.inspect
            logger.debug group.inspect

      change_record = ChangeHistory.new(:group_id => group_id,
        :new_counselors => new_values[:current_counselors],:old_counselors => group.current_counselors,
        :new_youth => new_values[:current_youth],:old_youth => group.current_youth,
        :updated_by => 1,
        :new_total => (new_values[:current_counselors].to_i + new_values[:current_youth].to_i),:old_total => group.current_total,
        :new_site => new_site_name,:old_site => old_site_name,
        :new_week => new_week_name,:old_week => old_week_name,
        :new_session => new_session_name,:old_session => old_session_name,
        :site_change => site_change,
        :week_change => week_change,
        :count_change => count_change)
      logger.debug change_record.inspect
      unless change_record.save! then
        flash[:error] = "Update of change record failed for unknown reason."
        render "edit"
      end
#Update ScheduledGroup
      if count_change then
        group.current_counselors = new_values[:current_counselors]
        group.current_youth = new_values[:current_youth]
        group.current_total = new_values[:current_counselors].to_i + new_values[:current_youth].to_i
      end

      if site_change || week_change then
        group.session_id = new_values[:session_id]
      end

      if group.update_attributes(group) then
        redirect_to change_confirmation_path(group_id)
      else
          flash[:error] = "Update of scheduled group record failed for unknown reason."
      end
    end
  end

  def change_success
    @scheduled_group = ScheduledGroup.find(params[:id])
    @session = Session.find(@scheduled_group.session_id)
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


    filename = File.join('app', 'views', 'email_templates', 'schedule_confirmation.text.erb')
    f = File.open(filename)
    body = f.read.gsub(/^  /, '')

    message = ERB.new(body, 0, "%<>")
    @email_body = message.result(binding)
    @title = "Change Success"
  end
end
