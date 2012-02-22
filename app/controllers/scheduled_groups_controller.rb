class ScheduledGroupsController < ApplicationController
#  skip_authorize_resource :only => :program_session
  authorize_resource
  require 'csv'
  require 'erb'
  before_filter :check_for_cancel, :only => [:update]
  before_filter :check_for_submit_changes, :only => [:update]

  def program_session
#TODO: This doesn't seem to be working
#    if current_admin_user.admin?
#      skip_authorize_resource
#    end
    session = Session.find(params[:session])
#   group = ScheduledGroup.find(params[:id])
    @groups = ScheduledGroup.find_all_by_session_id(session.id)
#   session = Session.find(group.session_id)
    @session_week = Period.find(session.period.id).name
    @session_site = Site.find(session.site_id).name
  end

  def confirmation       # before the confirmation screen
    @title = "Group Confirmation"
    @registration = Registration.find(params[:reg])
    church_name = Church.find(@registration.church_id).name
    if ScheduledGroup.find_all_by_registration_id(params[:reg]).count == 0
      @scheduled_group = ScheduledGroup.new(:church_id => @registration.church_id,
                        :name => @registration.name, :registration_id => @registration.id,
                        :current_youth => @registration.requested_youth,
                        :current_counselors => @registration.requested_counselors,
                        :current_total => @registration.requested_total,
                        :liaison_id => @registration.liaison_id, :session_id => params[:id],
                        :group_type_id => @registration.group_type_id,
                        :scheduled_priority => params[:priority],
                        :second_payment_total => 0)
    else if ScheduledGroup.find_all_by_registration_id(params[:reg]).count == 1
      @scheduled_group = ScheduledGroup.find_by_registration_id(params[:reg])
      if @scheduled_group.second_payment_total.nil?
        @scheduled_group.second_payment_total= 0
      end
         else
          flash[:error] = "Duplicate schedules exist for this registration. Contact support."
         end
    end

    @scheduled_group.save!
    roster = Roster.create!(:group_id => @scheduled_group.id,
      :group_type => SessionType.find(Session.find(@scheduled_group.session_id).session_type_id).id)
    @scheduled_group.update_attribute('roster_id', roster.id)
    log_activity("Group scheduled", "#{@scheduled_group.name} from #{church_name} for #{@registration.requested_total} participants")
    @session = Session.find(params[:id])
  end

  def update
    ## The final scheduling step is to set the scheduled flag on the registered record
    ## and to update the scheduled id in the payment records
    current_reg = Registration.find(ScheduledGroup.find(params[:id]).registration_id)
    current_reg.scheduled = true
    current_liaison = Liaison.find(current_reg.liaison_id)
    current_liaison.scheduled = current_liaison.registered = true
    if current_reg.update_attributes(current_reg) && current_liaison.update_attributes(current_liaison)
      redirect_to scheduled_group_confirmation_path(params[:id])
    else
      flash[:error] = "Update of registration/scheduled group record failed for unknown reason."
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
    @current_total = @scheduled_group.current_total
    message = ERB.new(body, 0, "%<>")
    @email_body = message.result(binding)
  end

  def edit
    @scheduled_group = ScheduledGroup.find(params[:id])
    @session = Session.find(@scheduled_group.session_id)
    @sessions = Session.find_all_by_session_type_id(@scheduled_group.group_type_id).map { |s| [s.name, s.id ]}
    @liaison = Liaison.find(@scheduled_group.liaison_id)
    @title = "Change Schedule"
    @notes = String.new
  end


  def change_success
    @scheduled_group = ScheduledGroup.find(params[:id])
    current_change = ChangeHistory.find(params[:change_id])
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
    @current_total = @scheduled_group.current_total
    @old_youth = current_change.old_youth
    @old_counselors = current_change.old_counselors
    @old_session = current_change.old_session
    @change_line1 = @change_line2 = @change_line3 = ''
    if current_change.site_change?
        @change_line1 = 'The site was changed from ' + current_change.old_site + ' to ' + @site + '.'
    end
    if current_change.week_change?
        @change_line2 = 'The week was changed from ' + current_change.old_week + ' to ' + @week + '.'
    end
    if current_change.count_change?
        @change_line3 = 'Total registration was changed from ' + current_change.old_total.to_s + ' to ' + @current_total.to_s + '.'
    end

    filename = File.join('app', 'views', 'email_templates', 'schedule_change.text.erb')
    f = File.open(filename)
    body = f.read.gsub(/^  /, '')

    message = ERB.new(body, 0, "%<>")
    @email_body = message.result(binding)
    @title = "Change Success"
  end

  def make_adjustment

    scheduled_group = ScheduledGroup.find(params[:id])
    liaison_name = Liaison.find(scheduled_group.liaison_id).name
    site_name = Site.find(Session.find(scheduled_group.session_id).site_id).name
    period_name = Period.find(Session.find(scheduled_group.session_id).period_id).name
    start_date = Period.find(Session.find(scheduled_group.session_id).period_id).start_date
    end_date = Period.find(Session.find(scheduled_group.session_id).period_id).end_date
    session_type = SessionType.find(Session.find(scheduled_group.session_id).session_type_id).name

    @screen_info = {:scheduled_group => scheduled_group,
      :site_name => site_name, :period_name => period_name, :start_date => start_date,
      :end_date => end_date,  :session_type => session_type,:adjustment => adjustment,
      :liaison_name => liaison_name}
    @title = "Make adjustment for: #{scheduled_group.name}"
  end


  def update_group_change
      @group_id = params[:id]
      @group = ScheduledGroup.find(@group_id)
      logger.debug params.inspect
      if can? :move, @group
        update_all_fields
      else
        update_only_counts
      end
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

  def invoice_report
    @invoices = build_invoice_report

    respond_to do |format|
      format.csv { create_csv("invoice-#{Time.now.strftime("%Y%m%d")}.csv") }
      format.html { @title = 'Invoice Report'}
    end
  end


private

  def create_csv(filename = nil)

      if request.env['HTTP_USER_AGENT'] =~ /msie/i
        headers['Pragma'] = 'public'
        headers["Content-type"] = "text/plain"
        headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
        headers['Expires'] = "0"
      else
        headers["Content-Type"] ||= 'text/csv'
        headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
      end
  end

  def build_invoice_report

    invoices = []

    ScheduledGroup.all.each do |group|
      church = Church.find(group.church_id)
      full_invoice = calculate_invoice_data(group.id)

    if full_invoice[:amount_paid] > full_invoice[:deposit_amount]
      dep_paid = full_invoice[:deposit_amount]
      dep_outstanding = 0
      remaining_balance = full_invoice[:amount_paid] - dep_paid
    else
      dep_paid = full_invoice[:amount_paid]
      dep_outstanding = full_invoice[:deposit_amount ] - dep_paid
      remaining_balance = 0
    end

    if remaining_balance > full_invoice[:second_payment_amount]     #second payment is covered
      sec_paid = full_invoice[:second_payment_amount]
      sec_outstanding = 0
      remaining_balance = remaining_balance - sec_paid
    else
      if remaining_balance > 0                                      #partially paid second payments
        sec_paid = remaining_balance
        sec_outstanding = full_invoice[:second_payment_amount] - sec_paid
        remaining_balance = 0
      else                                                          #zero remaining balance after second
        sec_paid = 0
        sec_outstanding = full_invoice[:second_payment_amount]
      end
    end

    if remaining_balance > full_invoice[:final_payment_amount]     #final payment is covered
      final_paid = full_invoice[:final_payment_amount]
      final_outstanding = 0
      remaining_balance = remaining_balance - final_paid
    else
      if remaining_balance > 0                                      #partially paid final payments
        final_paid = remaining_balance
        final_outstanding = full_invoice[:final_payment_amount] - final_paid
        remaining_balance = 0
      else                                                          #zero remaining balance after final
        final_paid = 0
        final_outstanding = full_invoice[:final_payment_amount]
      end
    end

    invoice = {:church_name => trim(church.name), :group_name => trim(group.name), :youth => group.current_youth,
                    :counselors => group.current_counselors,
                    :group_id => group.id,
                    :church_id => church.id,
                    :deposits_due => full_invoice[:deposits_due_count],
                    :deposits_paid => dep_paid,
                    :deposits_outstanding => dep_outstanding,
                    :second_payments_due => full_invoice[:second_payments_due_count],
                    :second_payments_paid => sec_paid,
                    :second_payments_outstanding => sec_outstanding,
                    :final_payments_due => group.current_total,
                    :final_payments_paid => final_paid,
                    :final_payments_outstanding => final_outstanding,
                    :adjustments => full_invoice[:adjustment_total],
                    :current_balance => full_invoice[:current_balance],
                    :total_due => full_invoice[:total_due] }

          invoices << invoice
    end
    invoices
  end

  def trim(s)
    if s.instance_of?(String)
      s.chomp.strip!
    end
    return s
  end


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
#Only include the final payments if the second payment has been made
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


  def update_all_fields
      new_values = params[:scheduled_group]
      logger.debug new_values.inspect
      site_change = week_change = count_change = false
      new_session_name = Session.find(new_values[:session_id]).name
      old_session_name = Session.find(@group.session_id).name
      new_week_name = Period.find(Session.find(new_values[:session_id]).period_id).name
      old_week_name = Period.find(Session.find(@group.session_id).period_id).name
      new_site_name = Site.find(Session.find(new_values[:session_id]).site_id).name
      old_site_name = Site.find(Session.find(@group.session_id).site_id).name
      if new_week_name != old_week_name then week_change = true end
      if new_site_name != old_site_name then site_change = true end

      new_total = new_values[:current_youth].to_i  + new_values[:current_counselors].to_i

      if (new_total != @group.current_total) || new_values[:current_youth].to_i != @group.current_youth  then
        count_change = true
      end

      change_record = ChangeHistory.new(:group_id => @group_id,
         :new_counselors => new_values[:current_counselors],:old_counselors => @group.current_counselors,
         :new_youth => new_values[:current_youth],:old_youth => @group.current_youth,
         :updated_by => @current_admin_user.id,
         :new_total => (new_values[:current_counselors].to_i + new_values[:current_youth].to_i),:old_total => @group.current_total,
         :new_site => new_site_name,:old_site => old_site_name,
         :new_week => new_week_name,:old_week => old_week_name,
         :new_session => new_session_name,:old_session => old_session_name,
         :site_change => site_change,
         :week_change => week_change,
         :count_change => count_change,
         :notes => @notes)
       if change_record.save! then
          flash[:notice] = "You have successfully completed this group change."
       else
          flash[:error] = "Update of change record failed for unknown reason."
          render "edit"
       end

#Update ScheduledGroup
      if count_change then
        @group.current_counselors = new_values[:current_counselors]
        @group.current_youth = new_values[:current_youth]
        @group.current_total = new_values[:current_counselors].to_i + new_values[:current_youth].to_i
      end

      if site_change || week_change then
        @group.session_id = new_values[:session_id]
      end

      if @group.second_payment_total.nil? then
        @group.second_payment_total= 0
      end

      if @group.update_attributes(@group) then
        log_activity("Group Update", "Count change: #{count_change} Session change: #{site_change || week_change}")
        redirect_to change_confirmation_path(@group_id, :change_id => change_record.id)
      else
          flash[:error] = "Update of scheduled group record failed for unknown reason (1)."
      end
  end

  def update_only_counts

     new_values = params[:scheduled_group]
     new_total = new_values[:current_youth].to_i  + new_values[:current_counselors].to_i

     if (new_total != @group.current_total) then
        count_change = true
     else
       count_change = false
     end

     if new_total > @group.current_total
        flash[:error] = "To increase your enrollment, you must contact the office."
        @scheduled_group = ScheduledGroup.find(params[:id])
        authorize! :read, @scheduled_group
        @session = Session.find(@scheduled_group.session_id)
        @sessions = Session.find_all_by_session_type_id(@scheduled_group.group_type_id).map { |s| [s.name, s.id ]}
        @liaison = Liaison.find(@scheduled_group.liaison_id)
        @title = "Change Schedule"
        params[:id => @group.id]
        render "edit"
     else
        change_record = ChangeHistory.new(:group_id => @group_id,
         :new_counselors => new_values[:current_counselors],:old_counselors => @group.current_counselors,
         :new_youth => new_values[:current_youth],:old_youth => @group.current_youth,
         :updated_by => 1,
         :new_total => new_total,:old_total => @group.current_total,
         :count_change => count_change,
         :notes => @notes)
       if change_record.save! then
          flash[:notice] = "You have successfully completed this group change."
       else
          flash[:error] = "Update of change record failed for unknown reason."
          render "edit"
       end

#Update ScheduledGroup
        if count_change then
          @group.current_counselors = new_values[:current_counselors]
          @group.current_youth = new_values[:current_youth]
          @group.current_total = new_values[:current_counselors].to_i + new_values[:current_youth].to_i
        end

        if @group.update_attributes(@group) then
          log_activity("Group Update", "Count changed to #{@group.current_total}")
          redirect_to change_confirmation_path(@group_id, :change_id => change_record.id)
        else
          flash[:error] = "Update of scheduled group record failed for unknown reason (2)."
          render "edit"
        end
     end
  end

  def check_for_submit_changes
    if params[:commit] == 'Submit Changes'
      update_group_change
    end
  end

  def check_for_cancel
    if params[:commit] == 'Cancel'
      ScheduledGroup.delete(params[:id])
      redirect_to admin_registrations_path
    end
  end
#TODO Refactor this out -duplicates code in liaisons controller
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
      event = [p.payment_date.to_date, "Payment Received", "", number_to_currency(p.payment_amount), shorten(p.payment_notes), p.id]
      event_list << event
    end

    changes.each do |c|
      if c.count_change?
        count_change = c.new_total - c.old_total
        amount_due = 0
        if count_change > 0
          if group.second_payment_date.nil?
            amount_due = count_change * payment_schedule.deposit
          else
            amount_due = count_change * (payment_schedule.deposit + payment_schedule.second_payment)
          end
        end
        event = [c.updated_at.to_date, "Enrollment change: #{c.new_total - c.old_total}", "#{number_to_currency(amount_due)}", ""]
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

  def log_activity(activity_type, activity_details)
    logger.debug current_admin_user.inspect
    a = Activity.new
    a.activity_date = Time.now
    a.activity_type = activity_type
    a.activity_details = activity_details
    a.user_id = current_admin_user.id
    a.user_name = current_admin_user.name
    a.user_role = current_admin_user.user_role
    unless a.save!
      flash[:error] = "Unknown problem occurred logging a transaction."
    end
  end

  def shorten(s)
    limit = 40
    if s.length > limit
      s = s[0, limit] + '...'
    end
    s
  end
end
