require 'csv'

class ChurchesController < ApplicationController
#  load_and_authorize_resource

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
      format.csv { create_csv("invoice-#{Time.now.strftime("%Y%m%d")}") }
      format.html { @title = 'Invoice Report'}
    end
  end


private

  def create_csv(name = nil)
      name ||= params[:action]
      name += '.csv'
      dir = "\\documents\\"
      path = ENV['USERPROFILE']
      filename = path + dir + name

    begin
      if File.exists?(filename)
        File.delete(filename)
      end

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

#      render :layout => false

      CSV.open(filename, 'w') do |csv|
        header = []
        header << 'Church Name' << 'Group Name' << 'Number Youth' << 'Number Counselors' << 'Total Number'
        header << 'Deposits Due' << 'Deposit $ Paid' << 'Deposit $ Outstanding' << 'Sec Payments Due'
        header << 'Sec Payment $ Paid' << 'Sec Payment $ Outstanding' << 'Final Payments Due'<< 'Final Payment $ Due'
        header << 'Final Payment $ Outstanding' << 'Adjustment' << 'Current Balance' << 'Total Due'
        csv << header

        @invoices.each do |i|
        row = []
          row << i[:church_name] << i[:group_name] << i[:youth] << i[:counselors] << (i[:youth] + i[:counselors])
          row << i[:deposits_due] << i[:deposits_paid] << i[:deposits_outstanding] << i[:second_payments_due]
          row << i[:second_payments_paid] << i[:second_payments_outstanding] << i[:final_payments_due]
          row << i[:final_payments_paid] << i[:final_payments_outstanding] << i[:adjustments]
          row << i[:current_balance] << i[:total_due]
          csv << row
        end
      flash[:notice] = "#{name} has been successfully created in #{path + dir}."
    end
    rescue => e
      logger.debug filename
          flash[:notice] = "#{filename} could not be created. Check if a file by that name is open."
  end

  redirect_to invoice_report_path :as => :html

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

    invoice = {:church_name => church.name, :group_name => group.name, :youth => group.current_youth,
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


end


