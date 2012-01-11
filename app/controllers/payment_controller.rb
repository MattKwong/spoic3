class PaymentController < ApplicationController
  before_filter :authenticate_admin_user!
  before_filter :check_for_cancel, :only => [:create]

  def new
    payment = Payment.new()
    payment_types = 'Check', 'Credit Card', 'Cash'
    scheduled_group = ScheduledGroup.find(params[:group_id])
    liaison_name = Liaison.find(scheduled_group.liaison_id).name
    site_name = Site.find(Session.find(scheduled_group.session_id).site_id).name
    period_name = Period.find(Session.find(scheduled_group.session_id).period_id).name
    start_date = Period.find(Session.find(scheduled_group.session_id).period_id).start_date
    end_date = Period.find(Session.find(scheduled_group.session_id).period_id).end_date
    session_type = SessionType.find(Session.find(scheduled_group.session_id).session_type_id).name

    @screen_info = {:scheduled_group => scheduled_group,
      :site_name => site_name, :period_name => period_name, :start_date => start_date,
      :end_date => end_date,  :session_type => session_type, :payment => payment, :payment_types => payment_types,
      :liaison_name => liaison_name}
    @title = "Record payment for: #{scheduled_group.name}"
  end

  def create

    payment = Payment.new(params[:payment])
    scheduled_group = ScheduledGroup.find(payment.scheduled_group_id)
    payment.registration_id = Registration.find_by_liaison_id(scheduled_group.liaison_id).id

    if payment.valid?
      payment.save!
      log_activity("Payment", "$#{sprintf('%.2f', payment.payment_amount)} paid for #{scheduled_group.name}")
      flash[:notice] = "Successful entry of new participant"
      redirect_to myssp_path(:id => scheduled_group.liaison_id)
    else
#      payment = Payment.new()
      payment_types = 'Check', 'Credit Card', 'Cash'
      scheduled_group = ScheduledGroup.find(payment.scheduled_group_id)
      liaison_name = Liaison.find(scheduled_group.liaison_id).name
      site_name = Site.find(Session.find(scheduled_group.session_id).site_id).name
      period_name = Period.find(Session.find(scheduled_group.session_id).period_id).name
      start_date = Period.find(Session.find(scheduled_group.session_id).period_id).start_date
      end_date = Period.find(Session.find(scheduled_group.session_id).period_id).end_date
      session_type = SessionType.find(Session.find(scheduled_group.session_id).session_type_id).name

      @screen_info = {:scheduled_group => scheduled_group,
        :site_name => site_name, :period_name => period_name, :start_date => start_date,
        :end_date => end_date,  :session_type => session_type, :payment => payment, :payment_types => payment_types,
        :liaison_name => liaison_name}
      @title = "Record payment for: #{scheduled_group.name}"
      render "payment/new"
    end
  end

private
  def log_activity(activity_type, activity_details)
    logger.debug @current_admin_user.inspect
    a = Activity.new
    a.activity_date = Time.now
    a.activity_type = activity_type
    a.activity_details = activity_details
    a.user_id = 1 #@current_admin_user.id
    a.user_name = "Name" #@current_admin_user.name
    a.user_role = "Liaison" #@current_admin_user.user_role
    unless a.save!
      flash[:error] = "Unknown problem occurred logging a transaction."
    end
  end

  def check_for_cancel
  unless params[:cancel].blank?
logger.debug params.inspect
    liaison_id = ScheduledGroup.find(params[:payment][:scheduled_group_id]).liaison_id
    redirect_to myssp_path(liaison_id)
    end
  end

end
