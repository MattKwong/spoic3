class PaymentController < ApplicationController
#  load_and_authorize_resource
  before_filter :check_for_cancel, :only => [:create]

#  def show
#    redirect_to admin_payment_path(params[:id])
#  end

  def new
    payment = Payment.new()
    payment_types = 'Deposit', 'Second', 'Final', 'Other'
    payment_methods = 'Check', 'Credit Card', 'Cash'
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
      :liaison_name => liaison_name, :payment_methods => payment_methods}
    @title = "Record payment for: #{scheduled_group.name}"
  end

  def create
    payment = Payment.new(params[:payment])
    scheduled_group = ScheduledGroup.find(payment.scheduled_group_id)
# The registration step check is here because some abandoned registration records exist in the db.
# The fix is to change the registration process and to store group_id in the payment record.
    payment.registration_id = Registration.find_by_liaison_id_and_registration_step(scheduled_group.liaison_id, 'Step 3').id

    if payment.valid?
      if payment.payment_type == 'Second'
        group = ScheduledGroup.find(payment.scheduled_group_id)
        group.second_payment_date = payment.payment_date
        group.second_payment_total=group.current_total
        if group.save!
          log_activity("Scheduled Group second payment date recorded: ", "$#{payment.payment_date} for #{scheduled_group.name}")
        else
          flash[:error] = "Unable to updated group record."
        end
      end
      payment.save!
      log_activity("Payment", "#{sprintf('%.2f', payment.payment_amount)} paid for #{scheduled_group.name}")
      flash[:notice] = "Successful entry of new payment."
      redirect_to myssp_path(:id => scheduled_group.liaison_id)
    else
      payment_types = 'Deposit', 'Second', 'Final', 'Other'
      payment_methods = 'Check', 'Credit Card', 'Cash'
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
        :liaison_name => liaison_name, :payment_methods => payment_methods}
      @title = "Record payment for: #{scheduled_group.name}"
      render "payment/new"
    end
  end

private
  def log_activity(activity_type, activity_details)
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
    liaison_id = ScheduledGroup.find(params[:payment][:scheduled_group_id]).liaison_id
    redirect_to myssp_path(liaison_id)
    end
  end

end
