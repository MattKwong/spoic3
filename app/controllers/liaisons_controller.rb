class LiaisonsController < ApplicationController
  load_and_authorize_resource
  layout 'admin_layout'

  def edit
    @page_title = "Edit Liaison Information: #{@liaison.name}"
  end

  def update
    logger.debug "Liaison update #{@liaison}"
    if @liaison.update_attributes(params[:liaison])
      flash[:success] = "Successful update of liaison information"
    else
      flash[:error] = "Update of liaison information failed."
    end
    redirect_to myssp_path(current_admin_user.liaison_id)
  end

  def show
    liaison = Liaison.find(params[:id])
    @page_title = "My SSP Information Portal. Welcome, #{liaison.first_name}!"
    church = Church.find(liaison.church_id)
    registrations = Registration.find_all_by_liaison_id(liaison.id) || []
    groups = ScheduledGroup.find_all_by_liaison_id(liaison.id)
#   authorize! :read, groups
    rosters = assemble_rosters(groups)
    invoices = grab_invoice_balances(groups)
    notes_and_reminders = Reminder.find_all_by_active(true, :order => 'seq_number')

    checklists = []
    for j in 0..groups.size - 1
      checklist = ChecklistItem.find(:all, :order => 'seq_number')
      checklist_item = []
      for i in 0..checklist.length - 1
        checklist_item[i] = {:name => checklist[i].name, :due_date => checklist[i].due_date,
        :notes => checklist[i].notes, :default_status => checklist[i].default_status,
        :status => get_checklist_status(groups[j], checklist[i], invoices[j])}
      end
      checklists[j] = checklist_item
    end

    documents = DownloadableDocument.find_all_by_active(true, :order => 'name')

    @screen_info = {:church_info => church, :registration_info => registrations,
      :group_info => groups, :invoice_info => invoices, :notes_and_reminders => notes_and_reminders,
      :checklist => checklists, :documents => documents,:roster_info => rosters, :liaison => liaison }
  end

  def create_user
    liaison = Liaison.find(params[:id])
    user = AdminUser.new
    user.admin = false
    user.email = liaison.email1
    user.first_name = liaison.first_name
    user.last_name = liaison.last_name
    user.liaison_id = liaison.id
    user.name = liaison.name
    user.user_role = "Liaison"
#    user.reset_password_token = AdminUser.reset_password_token
#    user.password = random_pronouncable_password(8)

    unless user.save!
      flash[:error] = "A problem occurred in create a logon for this liaison."
    else
      liaison.user_created = true
      unless liaison.save!
        flash[:error] = "A problem occurred in updating logon information for this liaison."
      else
        redirect_to admin_liaison_path(liaison.id)
      end
    end
  end

  private
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
      :second_payment_due_date => payment_schedule.second_payment_date,
      :second_payments_due_count => second_half_high_water, :second_payment_amount => second_pay_amount,
      :final_payment_amount => final_pay_amount, :second_late_payment_required => second_payment_late_due,
      :second_payment_late_amount => second_payment_late_amount, :final_late_payment_required => final_late_payment_due,
      :final_late_amount => final_late_payment_amount }
  end

  def number_to_currency(number)
    "$" + sprintf('%.2f', number)
  end

  def password_required?
    new_record? ? false : super
  end

  def random_pronouncable_password(size = 4)
    c = %w(b c d f g h j k l m n p qu r s t v w x z ch cr fr nd ng nk nt ph pr rd sh sl sp st th tr)
    v = %w(a e i o u y)
    f, r = true, ''
    (size * 2).times do
      r << (f ? c[rand * c.size] : v[rand * v.size])
      f = !f
    end
  r
  end

  def grab_invoice_balances(groups)
     invoices = []
     groups.each do |g|
       full_invoice = calculate_invoice_data(g.id)
       invoices << {:group_id => g.id, :current_balance => full_invoice[:current_balance],
                    :amount_paid => full_invoice[:amount_paid], :deposit_amount => full_invoice[:deposit_amount],
                    :second_payment_amount => full_invoice[:second_payment_amount],
                    :second_payment_due_date => full_invoice[:second_payment_due_date] }
     end
     invoices
  end

  def assemble_rosters(groups)
     rosters = []
     groups.each do |g|
       rosters << Roster.find_by_group_id(g.id)
     end
    rosters
  end

  def get_checklist_status(group, checklist, invoice)
# Find a checklist status item corresponding to the group and the checklist item. If none exists,
# return the default value except in those cases where we have defined specific logic.
# If one exists, return it.

    status = case checklist.name
      when "Deposit Paid"
         non_default_status = GroupChecklistStatus.find_by_group_id_and_checklist_item_id(group.id, checklist.id)
         if non_default_status.nil?
           calculate_deposit_status(group, checklist, invoice)
         else
           non_default_status.status
         end
      when "March Invoice Paid"
         non_default_status = GroupChecklistStatus.find_by_group_id_and_checklist_item_id(group.id, checklist.id)
         if non_default_status.nil?
           calculate_2nd_payment_status(group, checklist, invoice)
         else
           non_default_status.status
         end
      when "Rosters Completed"
         non_default_status = GroupChecklistStatus.find_by_group_id_and_checklist_item_id(group.id, checklist.id)
         if non_default_status.nil?
           calculate_roster_status(group)
         else
           non_default_status.status
         end
      when "Counselor Checks Completed"
         non_default_status = GroupChecklistStatus.find_by_group_id_and_checklist_item_id(group.id, checklist.id)
         if non_default_status.nil?
           checklist.default_status
         else
           non_default_status.status
         end

      else ""
    end
    return status
  end

  def calculate_deposit_status(group, checklist, invoice)
    if invoice[:amount_paid] >= invoice[:deposit_amount]
      "Paid"
    else
      "#{number_to_currency(invoice[:deposit_amount] - invoice[:amount_paid])} due"
    end
  end

  def calculate_2nd_payment_status(group, checklist, invoice)
    due = invoice[:deposit_amount] = invoice[:second_payment_amount]
    if invoice[:amount_paid] >= due
      "Paid"
    else
      if Date.today < invoice[:second_payment_due_date]
        "Not due yet"
      else
        "Past due"
      end
    end
  end

  def calculate_roster_status(group)
# find count of rosters items and current group size
    items = RosterItem.find_all_by_group_id(group.id).length
    group_size = group.current_total

    if items == group_size
      "Completed"
    else
      if items == 0
        "Not started"
      else
        if items < group_size
          "Incomplete: missing #{group_size - items}"
        else
          "Roster exceeds current enrollment!"
        end
      end
    end
  end

end