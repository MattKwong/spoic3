class ChurchesController < ApplicationController

  before_filter :authenticate_admin_user!

  def main
    liaison = Liaison.find(params[:id])
    church = Church.find(liaison.church_id)
    authorize! :update, liaison
    registrations = Registration.find_all_by_liaison_id(liaison.id) || []
    groups = ScheduledGroup.find_all_by_liaison_id(liaison.id)
#    authorize! :read, groups
    rosters = assemble_rosters(groups)
    invoices = grab_invoice_balances(groups)
    notes_and_reminders = Reminder.find_all_by_active(true, :order => 'seq_number')

    checklist = ChecklistItem.find(:all, :order => 'seq_number')
  #iterate through checklist, find each GroupChecklistStatus item and update checklist.status
    documents = DownloadableDocument.find_all_by_active(true, :order => 'name')

    @screen_info = {:church_info => church, :registration_info => registrations,
      :group_info => groups, :invoice_info => invoices, :notes_and_reminders => notes_and_reminders,
      :checklist => checklist, :documents => documents,:roster_info => rosters, :liaison => liaison }

  end

  def invoice
    @scheduled_group = ScheduledGroup.find(params[:id])
    liaison_name = Liaison.find(@scheduled_group.liaison_id).name
    site_name = Site.find(Session.find(@scheduled_group.session_id).site_id).name
    period_name = Period.find(Session.find(@scheduled_group.session_id).period_id).name
    start_date = Period.find(Session.find(@scheduled_group.session_id).period_id).start_date
    end_date = Period.find(Session.find(@scheduled_group.session_id).period_id).end_date
    session_type = SessionType.find(Session.find(@scheduled_group.session_id).session_type_id).name
    invoice = calculate_invoice_data(params[:id])
    church = Church.find(@scheduled_group.church_id)
    invoice_items = create_invoice_items(invoice)

    @screen_info = {:scheduled_group => @scheduled_group, :invoice_items => invoice_items,
      :site_name => site_name, :period_name => period_name, :start_date => start_date,
      :end_date => end_date,  :session_type => session_type, :invoice_data => invoice,
      :liaison_name => liaison_name, :church_info => church}
    @title = "Invoice for: #{@scheduled_group.name}"
  end

  def statement
    @scheduled_group = ScheduledGroup.find(params[:id])
    invoice = calculate_invoice_data(params[:id])
    @event_list = invoice[:event_list]

#Add header and footers to event_list for statement
    @event_list.insert(0, ["Date", "Item", "Amount Due", "Amount Received"])
    footer = ["", "Totals", number_to_currency(invoice[:total_due]), number_to_currency(invoice[:amount_paid])]
    @event_list << footer
    footer = ["", "Totals", number_to_currency(invoice[:current_balance]), ""]
    @event_list << footer
#Convert date column to formatted dates
    for i in 0..@event_list.size - 1
      if @event_list[i][0].instance_of?(Date)
        @event_list[i][0] = @event_list[i][0].strftime("%m/%d/%Y")
      end
    end

    @liaison_name = Liaison.find(@scheduled_group.liaison_id).name
    @site_name = Site.find(Session.find(@scheduled_group.session_id).site_id).name
    @period_name = Period.find(Session.find(@scheduled_group.session_id).period_id).name
    @start_date = Period.find(Session.find(@scheduled_group.session_id).period_id).start_date
    @end_date = Period.find(Session.find(@scheduled_group.session_id).period_id).end_date
    @church = Church.find(@scheduled_group.church_id)

  end

private
  def create_invoice_items(invoice)

    #Create invoice_items array
    invoice_items = Array[]
    item = ["Description", "Number of Persons", "Amount per Person", "Total"]
    invoice_items << item

    item = ["Deposits", invoice[:deposits_due_count],
      number_to_currency(invoice[:payment_schedule].deposit),
      number_to_currency(invoice[:deposit_amount])]
    invoice_items << item

    item = ["2nd Payments", invoice[:second_payments_due_count],
      number_to_currency(invoice[:payment_schedule].second_payment),
      number_to_currency(invoice[:second_payment_amount])]
    invoice_items << item
#Only include the final payments if teh second payment has been made
    unless @scheduled_group.second_payment_date.nil?
      item = ["Final Payments", @scheduled_group.current_total,
        number_to_currency(invoice[:payment_schedule].final_payment),
        number_to_currency(invoice[:final_payment_amount])]
      invoice_items << item
    end

    item = ["Total", "", "", number_to_currency(invoice[:deposit_amount] + invoice[:second_payment_amount] +
      invoice[:final_payment_amount])]
    invoice_items << item

    item = ["Paid to date", "", "", number_to_currency(invoice[:amount_paid])]
    invoice_items << item

    if invoice[:second_late_payment_required?]
      item = ["Second Payment Late Charge", "", "", number_to_currency(invoice[:second_late_payment_amount])]
      invoice_items << item
    end

    if invoice[:final_late_payment_required?]
      item = ["Second Payment Late Charge", "", "", number_to_currency(invoice[:final_late_payment_amount])]
      invoice_items << item
    end

    item = ["Less Adjustments", "", "", number_to_currency(invoice[:adjustment_total])]
    invoice_items << item

    item = ["Balance Due", "", "", number_to_currency(invoice[:current_balance])]
    invoice_items << item

  end

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
    original_reg = Registration.find(group.registration_id)
    payment_schedule = PaymentSchedule.find(Session.find(group.session_id).payment_schedule_id)
    payments = Payment.find_all_by_scheduled_group_id(group_id, :order => 'payment_date')
    adjustments = Adjustment.find_all_by_group_id(group.id)
    adjustment_total = Adjustment.sum(:amount, :conditions => ['group_id = ?', group.id])
    changes = ChangeHistory.find_all_by_group_id(group_id)
    late_payment_penalty = 0.1

#Find the overall high-water total.
    totals = changes.map { |i| i.new_total }
    totals << original_reg.requested_total << group.second_payment_total << group.current_total
    overall_high_water = second_half_high_water = totals.compact.max

#Find the high-water total since the 2nd payment
    unless group.second_payment_date.nil?
      totals = changes.map { |i| if i.created_at > group.second_payment_date
        i.new_total end }
      totals << group.second_payment_total << group.current_total
      second_half_high_water = totals.compact.max
    end

# Find the number of deposits owed:
    deposit_amount = overall_high_water * payment_schedule.deposit

#Find the number of second payments owed:
    second_pay_amount = second_half_high_water * payment_schedule.second_payment
    if (group.second_payment_date.nil? && Date.today > payment_schedule.second_payment_late_date) ||
        (!group.second_payment_date.nil? && group.second_payment_date > payment_schedule.second_payment_late_date)
      second_payment_late_due = true
      second_payment_late_amount = late_payment_penalty * second_pay_amount
    end

#Find the number of final payments owed:
     final_pay_amount = group.current_total * payment_schedule.final_payment
     if Date.today > payment_schedule.final_payment_late_date
       final_late_payment_due = true
       final_late_payment_amount = late_payment_penalty  * final_pay_amount
     end

     total_due = deposit_amount + second_pay_amount + final_pay_amount - adjustment_total
     amount_paid = Payment.sum(:payment_amount, :conditions => ['registration_id = ?', group.registration_id])
     current_balance = total_due - amount_paid

#Assemble event list
    event_list = Array.new

    adjustments.each do |a|
      event = [a.created_at.to_date, "Adjustment Code #{a.reason_code} (#{AdjustmentCode.find(a.reason_code).short_name})",
          number_to_currency(-a.amount), ""]
      event_list << event
    end

    payments.each do |p|
      event = [p.payment_date.to_date, "Payment Received", "", number_to_currency(p.payment_amount)]
      event_list << event
    end

    changes.each do |c|
      if c.count_change?
        event = [c.updated_at.to_date, "Enrollment change: #{c.new_total - c.old_total}", "", ""]
        event_list << event
      end
    end

    event = [original_reg.created_at.to_date, "Original registration. Deposit of #{number_to_currency(payment_schedule.deposit)} for #{original_reg.requested_total} persons",
              "#{number_to_currency(payment_schedule.deposit * original_reg.requested_total)}", ""]
    event_list << event

    if group.second_payment_date.nil?
      second_payment_due = true
      event = [payment_schedule.second_payment_date,"2nd payment of #{number_to_currency(payment_schedule.second_payment)} each for #{group.current_total} persons",
            "#{number_to_currency(payment_schedule.second_payment * group.current_total)}", ""]
    else
      event = [group.second_payment_date, "2nd payment of #{number_to_currency(payment_schedule.second_payment)} per person for #{group.second_payment_total} persons",
            "#{number_to_currency(payment_schedule.second_payment * group.second_payment_total)}", ""]
    end
    event_list << event

    event = [payment_schedule.final_payment_date, "Final payment of #{number_to_currency(payment_schedule.final_payment)} each for #{group.current_total} persons",
          "#{number_to_currency(payment_schedule.final_payment * group.current_total)}", ""]
    event_list << event

    event_list = event_list.sort_by { |item| item[0] }

    invoice = {:group_id => group_id,:current_balance => current_balance, :payments => payments,
      :adjustments => adjustments, :adjustment_total => adjustment_total, :changes => changes,
      :event_list => event_list, :total_due => total_due, :current_balance => current_balance,
      :amount_paid => amount_paid, :payment_schedule => payment_schedule, :second_payment_due => second_payment_due,
      :deposits_due_count => overall_high_water, :deposit_amount => deposit_amount,
      :second_payments_due_count => second_half_high_water, :second_payment_amount => second_pay_amount,
      :final_payment_amount => final_pay_amount, :second_late_payment_required => second_payment_late_due,
      :second_payment_late_amount => second_payment_late_amount, :final_late_payment_required => final_late_payment_due,
      :final_late_amount => final_late_payment_amount }
  end

  def number_to_currency(number)
    "$" + sprintf('%.2f', number)
  end
end


