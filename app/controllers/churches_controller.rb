class ChurchesController < ApplicationController

  before_filter :authenticate_admin_user!
#  load_and_authorize_resource

  def main
    liaison = Liaison.find(params[:id])
    logger.debug liaison.inspect
    church = Church.find(liaison.church_id)
    registrations = Registration.find_all_by_liaison_id(liaison.id) || []
    groups = ScheduledGroup.find_all_by_liaison_id(liaison.id)
    rosters = assemble_rosters(groups)
    invoices = grab_invoice_balances(groups)
    notes_and_reminders = Reminder.find_all_by_active(true, :order => 'seq_number')
    checklist = ChecklistItem.find(:all, :order => 'seq_number')

    documents = DownloadableDocument.find_all_by_active(true, :order => 'name')

    @screen_info = {:church_info => church, :registration_info => registrations,
      :group_info => groups, :invoice_info => invoices, :notes_and_reminders => notes_and_reminders,
      :checklist => checklist, :documents => documents,:roster_info => rosters, :liaison => liaison }
    logger.debug @screen_info.inspect
  end

  def invoice
    scheduled_group = ScheduledGroup.find(params[:id])
    liaison_name = Liaison.find(scheduled_group.liaison_id).name
    site_name = Site.find(Session.find(scheduled_group.session_id).site_id).name
    period_name = Period.find(Session.find(scheduled_group.session_id).period_id).name
    start_date = Period.find(Session.find(scheduled_group.session_id).period_id).start_date
    end_date = Period.find(Session.find(scheduled_group.session_id).period_id).end_date
    session_type = SessionType.find(Session.find(scheduled_group.session_id).session_type_id).name
    invoice = calculate_invoice_data(params[:id])
    @screen_info = {:scheduled_group => scheduled_group,
      :site_name => site_name, :period_name => period_name, :start_date => start_date,
      :end_date => end_date,  :session_type => session_type, :invoice_data => invoice,
      :liaison_name => liaison_name}
    @title = "Invoice for: #{scheduled_group.name}"
  end

  private
  def assemble_rosters(groups)
     rosters = []
     groups.each do |g|
       rosters << Roster.find_by_group_id(g.id)
     end
    rosters
  end

  def grab_invoice_balances(groups)
     invoices = []
     groups.each do |g|
       full_invoice = calculate_invoice_data(g.id)
       invoices << {:group_id => g.id, :current_balance => full_invoice[:current_balance] }
     end
    invoices
  end

  def calculate_invoice_data(group_id)
    group = ScheduledGroup.find(group_id)
    logger.debug group.inspect
    original_reg = Registration.find(group.registration_id)
    payment_schedule = PaymentSchedule.find(Session.find(group.session_id).payment_schedule_id)
    payments = Payment.find_all_by_scheduled_group_id(group_id, :order => 'payment_date')
    adjustments = Adjustment.find_all_by_group_id(group_id)
    changes = ChangeHistory.find_all_by_group_id(group_id)

#TODO invoice calculation logic goes here and data is returned in 'invoice' hash. should include the following
    #for deposits, 2nd payments and final payments: number owed, amount for each, total due
#    if (group.current_total == original_reg.requested_total) then  #this is the most straightforward case
      total_due = group.current_total * payment_schedule.total_payment
      amount_paid = Payment.sum(:payment_amount, :conditions => ['registration_id = ?', group.registration_id])
      current_balance = total_due - amount_paid
#    end

    invoice = {:group_id => group_id,:current_balance => current_balance, :payments => payments,
      :adjustments => adjustments, :changes => changes}
  end
end


