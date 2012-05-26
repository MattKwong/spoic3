class LaborItemsController < ApplicationController
  layout '_ops_layout'
  load_and_authorize_resource :program
  load_and_authorize_resource :project #, :through => :program, :shallow => true
  load_and_authorize_resource :labor_item, :through => :project, :shallow => true
#  before_filter :check_for_cancel, :only => [:create, :update]

  def index

  end

  def new
    @project = Project.find(params[:id])
    @title = "#{@project.program.short_name}: Record Labor for Project: #{@project.name}"
    @labor_item = LaborItem.new
    @labor_item.project_id= @project.id
    @user_list = Hash[@project.program.program_users.map {|u| ["#{u.admin_user.name}", u.admin_user.id ]}]
  end

  def create
    @labor_item = LaborItem.new(params[:labor_item])
    @project= @labor_item.project
#    logger.debug @project
    if @labor_item.save && update_project
      flash[:success] = "New labor item has been successfully created."
      redirect_to @project
    else
      flash[:warning] = "Errors prevented this record from being saved."
      @title = "#{@project.program.short_name}: Record Labor for Project: #{@project.name}"
      @user_list = Hash[@project.program.program_users.map {|u| ["#{u.admin_user.name}", u.admin_user.id ]}]
      redirect_to @project
    end
  end

  def update_project
#update stage to 'In progress' if it isn't already'
    result = true
    if @project.actual_start.nil?
      @project.actual_start = @labor_item.session.session_start_date
      update = true
    end
    unless @project.stage_in_progress?
      @project.stage= 'In progress'
      update = true
    end
    if update
      unless @project.save
        result = false
      end
    end
    result
  end


  def show
  end

  def destroy
    @labor_item = LaborItem.find(params[:id])
    @project = Project.find(@labor_item.project_id)
    if @labor_item.destroy
      flash[:success] = "These volunteer days have been removed successfully"
    else
      flash[:error] = "Could not remove volunteer days"
    end
    redirect_to @project
  end

  def update
  end

  def edit
  end

end
