class RegistrationController < ApplicationController
  load_and_authorize_resource
  layout 'admin_layout'

  def index
    @title = "Manage Groups"
  end

  def register                #prior to display of register view
      @registration = Registration.new
      authorize! :create, @registration
      @liaisons = Liaison.all.map { |l| [l.name, l.id ]}
      @group_types = SessionType.all.map { |s| [s.name, s.id ]}
      @title = "Register A Group"
      @page_title = "Register A Group"
      render "register"
  end

  def create       #triggered by register view
    @registration = Registration.new(params[:registration])
    authorize! :create, @registration
    if (@registration.valid?)
      @registration.save!
      flash[:notice] = "Successful completion of Step 1!"
      redirect_to edit_registration_path(:id => @registration.id)
    else
      @liaisons = Liaison.all.map { |l| [l.name, l.id ] }
      @group_types = SessionType.all.map { |s| [s.name, s.id ] }
      @title = "Register A Group"
      render "register"
    end
  end

  def edit              #prior to /:id/edit view
    @registration = Registration.find(params[:id])
    authorize! :edit, @registration
    @liaison = Liaison.find(@registration.liaison_id)
    @church = Church.find(@liaison.church_id)
    @group_type = SessionType.find(@registration.group_type_id)
    @temp = Array.new()
    @temp << "None" << 0
    @sessions = Session.find_all_by_session_type_id(@registration.group_type_id).map { |s| [s.name, s.id ]}
    @sessions.insert(0, @temp)
    @title = "Registration Step 2"
  end

  def step2?
    @registration.registration_step == 'Step 2'
  end

  def step3?
    @registration.registration_step == 'Step 3'
  end

  def update          #follows posting of edit and process_payment forms
    @registration = Registration.find(params[:id])
    authorize! :update, @registration
    @liaison = Liaison.find(@registration.liaison_id)
    @group_type = SessionType.find(@registration.group_type_id)
    @registration.church_id = @liaison.church_id
    total_requested = @registration.requested_counselors + @registration.requested_youth
    @registration.requested_total = total_requested
    @registration.scheduled = false
    @church = Church.find(@liaison.church_id)
    @registration.update_attributes(params[:registration])
    @payment_types = 'Check', 'Credit Card', 'Cash'


    if (step2?) then
      if @registration.update_attributes(params[:registration])
        flash[:success] = "Successful completion of Step 2"
        redirect_to registration_payment_path(:id => @registration.id)
      else
        @sessions = Session.all.map  { |s| [s.name, s.id ]}
        @sessions.insert(0, @temp)
        @title = "Registration Step 2"
        render "edit"
      end
    end

    if (step3?)
      if @registration.update_attributes(params[:registration]) then
        @payment = Payment.new
        @payment.registration_id = @registration.id
        @payment.payment_method = @registration.payment_method
        @payment.payment_amount=@registration.amount_paid
        @payment.payment_date=Date.today
        @payment.payment_notes=@registration.payment_notes
        @church.registered=true
        if @payment.save && @church.save then
          flash[:success] = "Successful completion of step 3"
          redirect_to registration_success_path(:id => @registration.id)
        else
          @title = "Registration Step 3"
          render "update"
        end
      end
    end
  end

  def process_payment   #prior to rendering process_payment step 3
    @registration = Registration.find(params[:id])
    authorize! :update, @registration
    @liaison = Liaison.find(@registration.liaison_id)
    @church = Church.find(@liaison.church_id)
    @group_type = SessionType.find(@registration.group_type_id)
    @session = Session.find(@registration.request1)
    @payment_schedule = PaymentSchedule.find(@session.payment_schedule_id)
    @registration.amount_due= @payment_schedule.deposit * (@registration.requested_counselors + @registration.requested_youth)
    @payment_types = 'Check', 'Credit Card', 'Cash'
    @title = "Registration Step 3"
  end

  def successful
    @title = "Completed Registration"
    @registration = Registration.find(params[:id])
    @church = Church.find(@registration.church_id)
    @liaison = Liaison.find(@registration.liaison_id)
    @session = Session.find(@registration.request1)
  end

  def schedule
    @title = "Schedule a Group"
    @registration = Registration.find(params[:id])
    authorize! :update, @registration
    @church = Church.find(@registration.church_id)
    @liaison = Liaison.find(@registration.liaison_id)
    @session = Session.find(@registration.request1)
    @site = Site.find(@session.site_id)
    @period = Period.find(@session.period_id)
    @requests = Array[@registration.request1, @registration.request2, @registration.request3,
        @registration.request4, @registration.request5, @registration.request6,
        @registration.request7, @registration.request8, @registration.request9,
        @registration.request10]

    first_nil = @requests.index(nil)
    if first_nil.nil?
      first_nil = 10
    end

    first_zero = @requests.index(0)
    if first_zero.nil?
      first_zero = 10
    end
    @requests_size = (first_nil < first_zero ? first_nil : first_zero)
    @requests.slice!(@requests_size, @requests.size - @requests_size)
    @sessions = Session.all
    @selection = 0
    @alt_sessions = Session.find_all_by_session_type_id(@registration.group_type_id).map  { |s| [s.name, s.id]}
    @requests.each { |i| @alt_sessions.delete_if { |j| j[1] == i }}
  end

  def alt_schedule
    @priority = params[:priority]
    @session_id = params[:id]
    @registration = params[:reg]
    redirect_to scheduled_groups_schedule_path(:priority => @priority, :reg => @registration, :id => @session_id)
  end

  def show_schedule
    build_schedule(params[:reg_or_sched], params[:type])
  end

  def program_session
    @requests = Registration.find_all_by_request1(params[:id])
    session = Session.find(params[:id])
    @session_week = Period.find(session.period.id).name
    @session_site = Site.find(session.site_id).name
  end

  private

  def build_schedule(reg_or_sched, type)

    @schedule = {}
    if type == "summer_domestic" then
      @site_names = Site.order(:listing_priority).find_all_by_active_and_summer_domestic(true, true).map { |s| s.name}
#      @site_names = Site.order(:listing_priority).find_all.map { |s| s.name}
      @period_names = Period.order(:start_date).find_all_by_active_and_summer_domestic(true, true).map { |p| p.name}
#      @period_names = Period.order(:start_date).find_all.map { |p| p.name}
      @title = "Domestic Summer Schedule"
    else
      @site_names = Site.order(:listing_priority).find_all_by_active_and_summer_domestic(true, false).map { |s| s.name}
#      @site_names = Site.order(:listing_priority).find_all.map { |s| s.name}
      @period_names = Period.order(:start_date).find_all_by_active_and_summer_domestic(true, false).map { |p| p.name}
#      @period_names = Period.order(:start_date).find_all.map { |p| p.name}
      @title = "Special Program Schedule"
    end

    @period_ordinal = Array.new
    for i in 0..@period_names.size - 1 do
      @period_ordinal[i] = @period_names[i]
    end

    @site_ordinal = Array.new
    for i in 0..@site_names.size - 1 do
      @site_ordinal[i] = @site_names[i]
    end

    @registration_matrix = Array.new(@site_names.size + 1){ Array.new(@period_names.size + 1, 0)}
    @scheduled_matrix = Array.new(@site_names.size + 1){ Array.new(@period_names.size + 1, 0)}
    @session_id_matrix = Array.new(@site_names.size + 1){ Array.new(@period_names.size + 1, 0)}

#    Registration.find_all_by_request1_and_scheduled(not nil, false).each do |r|
    Registration.all(:conditions => "(request1 IS NOT NULL) AND (scheduled = 'f')").each do |r|
        @session = Session.find(r.request1)
        @site = Site.find(@session.site_id)
        @period = Period.find(@session.period_id)
        @row_position = @site_ordinal.index(@site.name)
        @column_position = @period_ordinal.index(@period.name)
        @session_id_matrix[@row_position][@column_position] = @session.id
        @registration_matrix[@row_position][@column_position] += r.requested_counselors + r.requested_youth
          unless (@column_position.nil? || @row_position.nil?)
          end

    end

    ScheduledGroup.all.each do |r|
        @session = Session.find(r.session_id)
        @site = Site.find(@session.site_id)
        @period = Period.find(@session.period_id)
        @row_position = @site_ordinal.index(@site.name)
        @column_position = @period_ordinal.index(@period.name)
        @session_id_matrix[@row_position][@column_position] = @session.id
        @scheduled_matrix[@row_position][@column_position] += r.current_total
          unless (@column_position.nil? || @row_position.nil?)
          end
    end
#total the rows and columns
    @reg_total = 0
    @sched_total = 0
    for i in 0..@site_names.size - 1 do
      for j in 0..@period_names.size - 1 do
        @reg_total = @reg_total + @registration_matrix[i][j]
        @sched_total = @sched_total + @scheduled_matrix[i][j]
      end
      @registration_matrix[i][@period_names.size] = @reg_total
      @scheduled_matrix[i][@period_names.size] = @sched_total
      @reg_total = @sched_total = 0
    end

    @reg_total = 0
    @sched_total = 0
    for j in 0..@period_names.size - 1 do
      for i in 0..@site_names.size - 1 do
        @reg_total = @reg_total + @registration_matrix[i][j]
        @sched_total = @sched_total + @scheduled_matrix[i][j]
      end
      @registration_matrix[@period_names.size - 1][j] = @reg_total
      @scheduled_matrix[@period_names.size - 1][j] = @sched_total
      @reg_total = @sched_total = 0
    end

    #Grand total
    @reg_total = @sched_total = 0
    for i in 0..@site_names.size - 1 do
      @reg_total = @reg_total + @registration_matrix[i][@period_names.size]
      @sched_total = @sched_total + @scheduled_matrix[i][@period_names.size]
    end
    @registration_matrix[@site_names.size][@period_names.size] = @reg_total
    @scheduled_matrix[@site_names.size][@period_names.size] = @sched_total

    @period_names << "Total"
    @site_names << "Total"
    @schedule = { :site_count => @site_names.size - 1, :period_count => @period_names.size - 1,
                  :site_names => @site_names, :period_names => @period_names,
                  :registration_matrix => @registration_matrix, :scheduled_matrix => @scheduled_matrix,
                  :session_id_matrix => @session_id_matrix, :reg_or_sched => reg_or_sched, :type => type}
  end
 end

