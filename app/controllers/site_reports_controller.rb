class SiteReportsController < ApplicationController
  layout '_ops_layout'
  before_filter :get_program, :except => :list
#  load_and_authorize_resource

  def show
    @title = "Reports"
    @programs = Program.accessible_by(current_ability, :site_report)
  end

  def inventory
    @program = Program.find(current_admin_user.program_id)
    @title = "Inventory Report: #{@program}"
    @date = (Date.parse(params[:date]) if params[:date]) || Date.today
    @items = Item.all_for_program(@program)

  end

  def budget
    @title = "Budget Report: #{@program}"
    @sessions = @program.sessions
  end

  def consumption
    @title = "Consumption Report: #{@program}"
    @food_items  = @program.purchased_items
    @inventories = @program.food_inventories
  end

  def session
    @title = "Session Costs: #{@program}"
  end

  protected

  def get_program
    @program = Program.find(current_admin_user.program_id)
    #@program = current_admin_user.current_program ||
    #  (Program.find(params[:id]) if params[:id]) ||
    #  Program.current.first
    #authorize! :site_report, @program
    #logger.debug :site_report
    #logger.debug @program.inspect

  end

end
