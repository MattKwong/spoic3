class ProgramsController < ApplicationController
  layout 'admin_layout'
  load_and_authorize_resource

  autocomplete :admin_user, :name, :full => true, :scopes => [:staff]

  #def autocomplete_user_name
  #  @program = Program.find(params[:program_id])
  #  @users = (User.not_admin.search_by_name(params[:term]) - @program.users)
  #  render :json => json_for_autocomplete(@users, :name, nil)
  #end

  #def autocomplete_food_item
  #  @program = Program.find(params[:program_id])
  #  @food_items = FoodItem.all_for_program(@program).search_by_name(params[:term])
  #  render :json => json_for_autocomplete(@food_items, :name, nil)
  #end

 def index
    @page_title = "Programs"
    program_user = ProgramUser.find_by_user_id(current_admin_user.id)
    if current_admin_user.staff?
      @active_programs = Program.find(program_user.program_id)
    else
      @active_programs = Program.current
    end
  end

  def show

    #if current_admin_user.admin?
    #  session[:program] = @program.id
    ##  #logger.debug session[:program].inspect
    #end

    @scope = params[:scope]
    @page_title = @program.name

    @budget_type_id = BudgetItemType.find_by_name('Food').id

  end

  def edit
    @page_title = "Editing: #{@program.name}"
  end

  def get_budget_items
    @budget_items = @program.budget_items
    render :partial => "budget_items"
  end

  def get_food_items
    @sessions ||= @program.to_current
    @budget_type_id ||= BudgetItemType.find_by_name('Food').id
    render :partial => "food_items"
  end

  def get_projects_items

    render :partial => "projects_items"
  end

  def get_purchases_items
    @scope ||= 'past7'
    case @scope
      when 'All', nil
        @scoped_purchases = Purchase.for_program(@program).newest_first
      when 'past7'
        @scoped_purchases = Purchase.for_program(@program).past_week.newest_first
      when 'unaccounted'
        @scoped_purchases = Purchase.for_program(@program).all.sort{ |a,b| b.unaccounted_for.abs <=> a.unaccounted_for.abs}
      when 'alphabetized'
        @scoped_purchases = Purchase.for_program(@program).all.sort{ |a,b| b.unaccounted_for.abs <=> a.unaccounted_for.abs}
    end
    render :partial => "purchases_items"
  end

  def get_sessions_items

    render :partial => "sessions_items"
  end

  def get_staff_items

    render :partial => "staff_items"
  end

  def update
    if @program.update_attributes(params[:program])
      flash[:success] = "#{@program.name} updated successfully"
      redirect_to @program
    else
      @page_title = "Editing: #{@program.name}"
      render :edit
    end
  end

end
