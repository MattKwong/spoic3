class ProjectsController < ApplicationController
  layout 'admin_layout'
  load_and_authorize_resource :program
  load_and_authorize_resource :project, :through => :program, :shallow => true

  def index
    authorize! :see_projects_for, @program unless @program.nil?
    redirect_to program_projects_path(current_admin_user.current_program) if ( @program.nil? && cannot?(:manage, Project))
    @page_title = @program.nil? ? "Projects" : "Projects for #{@program}"
    unless @program.nil?
      @menu_actions = [{:name => "New", :path => new_program_project_path(@program) }] if can? :create, Project
    end
    @projects = @projects.order('planned_start ASC').page(params[:page]).per(10)
  end

  def new
    @page_title = "Create a new project"
    start_date = @program.first_session_start > Date.today ? @program.first_session_start : Date.today
    @project.planned_start = start_date.to_date + 1
    end_date = @program.last_session_end < start_date + 14 ? @program.last_session_end - 1 : start_date + 14
    @project.planned_end = end_date.to_date
  end

  def update
    if @project.update_attributes(params[:project])
      flash[:success] = "Project updated successfully"
      redirect_to @project
    else
      @page_title = "Editing #{@project.name}"
      render :edit
    end
  end

  def calculate_tracked_cost
    items = MaterialItemEstimated.find_all_by_project_id(@project.id)
    total_tracked_cost =0
    items.each { |i| total_tracked_cost += i.cost(@project.program) }
    total_tracked_cost
  end

  def calculate_cost
    if @project.project_subtype.untracked_percentage == 100
      0
    else
      calculated_cost = calculate_tracked_cost/(1 - @project.project_subtype.untracked_percentage)
    end
  end

  def update_cost
    @project.update_attribute(:estimated_cost, calculate_cost)
  end

    def edit
    @page_title = "Editing #{@project.name}"
  end

  def delete
  end

  def show
    @page_title = "#{@project.name}"
    if session[:program]
      add_breadcrumb Program.find(session[:program]).name, program_path(session[:program])
    end
    nonstandard_item_list = Hash[Item.materials.all_for_program(@project.program).tracked.alphabetized.map {|i| [i.id, i.name]}]
    standard_item_list =
        Hash[StandardItem.find_all_by_project_subtype_id(@project.project_subtype_id).map {|s| [s.item_id, "#{s.item.name} (#{s.comments})"]}]
    existing_item_list = Hash[MaterialItemEstimated.find_all_by_project_id(@project.id).map {|e| [e.item_id, e.item.name]}]

    standard_item_list.each {|s| nonstandard_item_list.delete(s[0])}
    existing_item_list.each {|s| nonstandard_item_list.delete(s[0])}
    existing_item_list.each {|s| standard_item_list.delete(s[0])}
    @nonstandard_item_list = nonstandard_item_list.invert

    @standard_item_list = standard_item_list.invert
    @existing_item_list = existing_item_list.invert
    @item_list = Hash[@project.material_item_estimateds.map {|i| ["#{i.item.name}", i.item_id ]}]
    @user_list = Hash[@project.program.program_users.map {|u| ["#{u.admin_user.name}", u.admin_user.id ]}]
    @material_item_delivered = MaterialItemDelivered.new
    @material_item_delivered.delivery_date = Date.today
    @material_item_delivered.quantity= 1
    @material_item_delivered.project_id= @project.id

    @labor_item = LaborItem.new
    #@material_item_delivered.delivery_date = Date.today
    #@material_item_delivered.quantity= 1
    @labor_item.project_id= @project.id
  end

  def create
    @project.program_id = @program.id
    #@project.estimated_cost = 0
    @project.created_by = current_admin_user.id
    @project.stage= 'New'
    if @project.save
      flash[:success] = "New project has been successfully created."
      redirect_to @project
    else
      flash[:warning] = "Errors prevented this record from being saved."
      @page_title = "Create a new project"
      render :new
    end
  end

  def move_stage
    if @project.stage_new?
      @project.stage= 'Ready for review'
    else if @project.stage == 'Ready for review'
        if @project.actual_start.nil?
          @project.stage= 'Approved'
        else
          @project.stage= 'In progress'
        end
      else if @project.stage == 'In progress'
          @project.stage= 'Complete'
        end
      end
    end

    if @project.save
      flash[:success] = "Project has been moved to the next stage."
    else
      flash[:error] = "A problem occurred in moving the project to the next stage."
    end
    redirect_to @project
  end

  def destroy
# We won't allow a project to be delete once materials or labor has been recorded against it.
#    logger.debug @project.inspect
#    logger.debug @project.program.inspect
    if @project.labor_items.any? || @project.material_item_delivereds.any?
      flash[:warning] = "This project cannot be deleted because either labor or materials have been recorded against it."
      redirect_to program_project_path(@project.program)
    else
      if @project.destroy
        flash[:notice] = "Successful deletion of project #{@project.name}."
        redirect_to current_admin_user.program_user.program
      else
        flash[:error] = "An unknown problem prevented #{@project.name} from being deleted."
        render :back
      end
    end
  end

end
