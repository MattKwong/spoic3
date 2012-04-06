class SiteReportsController < ApplicationController
  layout '_ops_layout'
  before_filter :get_program, :except => :show
#  load_and_authorize_resource

  def show
    @title = "Food Reports"
    @programs = Program.accessible_by(current_ability, :site_report)
  end

  def food_inventory
    @program = Program.find(params[:id])
    @title = "Food Inventory Report: #{@program}"
    @date = (Date.parse(params[:date]) if params[:date]) || Date.today
    @items = Item.food.all_for_program(@program)
    @budget_type_id = BudgetItemType.find_by_name('Food').id
  end

  def food_budget
    @title = "Food Budget Report: #{@program}"
    @sessions = @program.sessions
    @budget_type_id = BudgetItemType.find_by_name('Food').id
  end

  def food_consumption
    @program = Program.find(params[:id])
    @title = "Food Consumption Report: #{@program}"
    @items  = @program.purchased_food_items
    @inventories = @program.food_inventories
  end

  def session
    @title = "Session Costs: #{@program}"
  end

  protected

  def get_program
    program_id = current_admin_user.program_id
    if program_id == 0
      @program = Program.current
    else
      @program = Program.find(current_admin_user.program_id)
    end


    #@program = current_admin_user.current_program ||
    #  (Program.find(params[:id]) if params[:id]) ||
    #  Program.current.first
    #authorize! :site_report, @program
    #logger.debug :site_report
    #logger.debug @program.inspect

  end

end
