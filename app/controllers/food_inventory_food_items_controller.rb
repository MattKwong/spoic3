class FoodInventoryFoodItemsController < ApplicationController
  layout 'admin_layout'
  load_and_authorize_resource :program

  def new
    @food_inventory = FoodInventory.find(params[:food_inventory_id])
    @page_title = "Record Inventory Results"
    @food_inventory_food_item = FoodInventoryFoodItem.new
    @food_inventory_food_item.food_inventory_id= @food_inventory.id

  end

  def create
    @food_inventory_food_item  = FoodInventoryFoodItem.new(params[:food_inventory_food_item ])
    @food_inventory = @food_inventory_food_item.food_inventory
#    logger.debug @project
    if @food_inventory_food_item.save
      flash[:success] = "Inventory results for #{@food_inventory_food_item.item.name} have been successfully recorded."
      redirect_to @food_inventory
    else
      flash[:warning] = "Errors prevented this inventory record from being saved."
      @page_title = "#{@food_inventory.program.name} #{@food_inventory.date}: Record inventory Results"
      @user_list = Hash[@project.program.program_users.food.map {|u| ["#{u.admin_user.name}", u.admin_user.id ]}]
      refresh :new
    end
  end

end
