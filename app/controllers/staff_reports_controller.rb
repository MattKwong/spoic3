class StaffReportsController < ApplicationController
  layout 'admin_layout_alt'
  before_filter :get_program, :except => :show
#  load_and_authorize_resource
  require 'csv'

  def show
    @page_title = "Food Reports"
    @programs = Program.accessible_by(current_ability, :site_report)
  end

  def food_inventory
    @program = Program.find(params[:id])
    @page_title = "Food Inventory Report: #{@program}"
    @date = (Date.parse(params[:date]) if params[:date]) || Date.today
    @items = Item.food.all_for_program(@program)
    @budget_type_id = BudgetItemType.find_by_name('Food').id
  end

  def materials_inventory
    @program = Program.find(params[:id])
    @page_title = "Materials Inventory Report: #{@program}"
    @date = (Date.parse(params[:date]) if params[:date]) || Date.today
#For testing
#    @date = (Date.parse(params[:date]) if params[:date]) || "07/08/2012".to_date
    @items = Item.materials.all_for_program(@program)
    @items.sort_by! {|a| -a.construction_onhand(@program) }
    @budget_type_id = BudgetItemType.find_by_name('Materials').id

  end

  def food_reconciliation
    @program = Program.find(params[:id])
    @page_title = "Food Reconciliation Report: #{@program}"
    @date = (Date.parse(params[:date]) if params[:date]) || Date.today
#For testing
#    @date = (Date.parse(params[:date]) if params[:date]) || "07/08/2012".to_date
#    @items = Item.food.all_for_program(@program).alphabetized.first(25)
    @inventories = @program.food_inventories
    @items = assemble_items(@program, @date)
    @budget_type_id = BudgetItemType.find_by_name('Food').id

  end

  def assemble_items(program, date)
    report_items = Array.new
    Item.food.all_for_program(program).each do |item|
      all_inv = 0
      if @inventories.any?
        inv_array = Array.new(@inventories.count)
        index = 0
        @inventories.each do |inventory|
          if inventory.food_inventory_food_items.for_item(item).any?
            inv_array[index] = inventory.food_inventory_food_items.for_item(item).last.consumed
            all_inv += inv_array[index]
          end
          index += 1
        end
      end
      item = {:item => item, :name => item.name, :total_purchased => item.purchased_for_program(program, program.start_date, date),
              :current_in_inventory => item.in_inventory_for_program_at(program, date),
              :base_unit => item.base_unit, :average_cost => item.average_cost(program, date),
              :value_at_cost => item.inventory_value_at_cost(program, date),
              :purchased_for_program => item.purchased_for_program_value(program, program.start_date, date),
              #:consumed => (all_inv.map &:consumed).sum,
              #:total_consumed_cost => (all_inv.map &:total_consumed_cost).sum,
              :inventories => inv_array,
              :all_inventories => all_inv
      }
      report_items << item
    end

    #remove zero items
    report_items.delete_if do |i|
      i[:total_purchased] == 0 && (i[:current_in_inventory] == 0)
    end

    report_items.sort{|a,b| a[:name] <=> b[:name]}
  end

  def food_budget
    @program = Program.find(params[:id])
    @page_title = "Food Budget Report: #{@program}"
    @sessions = @program.sessions
    @budget_type_id = BudgetItemType.find_by_name('Food').id
  end

  def food_consumption
    @program = Program.find(params[:id])
    @page_title = "Food Consumption Report: #{@program}"
    @items  = @program.purchased_food_items
    @inventories = @program.food_inventories
  end

  def session
    program_id = current_admin_user.program_id
    if program_id == 0
      @program = Program.current
      @page_title = "Food Costs by Session: #{@program}"
    else
      @program = Program.find(current_admin_user.program_id)
      @page_title = "Food Costs by for all sessions"
    end
  end

  def spending_report
    @page_title = "Spending Report"



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
