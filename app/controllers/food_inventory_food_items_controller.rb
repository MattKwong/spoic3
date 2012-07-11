class FoodInventoryFoodItemsController < ApplicationController
  layout 'admin_layout'
  load_and_authorize_resource :program

  def new
    @food_inventory = FoodInventory.find(params[:food_inventory_id])
    @page_title = "Record Inventory Results"
    @food_inventory_food_item = FoodInventoryFoodItem.new
    @food_inventory_food_item.food_inventory_id= @food_inventory.id
    #logger.debug @food_inventory.inspect
  end

  def update_item_info
    @program = FoodInventory.find(params[:food_inventory_id]).program
    logger.debug @program
    item = Item.find(params[:id])
    @base_unit = item.base_unit
    last_inventory = FoodInventoryFoodItem.for_program(@program).find_all_by_item_id(item.id)
    if last_inventory.count > 0
      @last_inventory_date = last_inventory.first.created_at.in_time_zone("Pacific Time (US & Canada)").strftime("%b %d @ %I:%M %p")
      @last_inventory_amount = last_inventory.first.quantity
    else
      @last_inventory_date = "None"
      @last_inventory_amount = "None"
    end
    last_purchase = ItemPurchase.for_program(@program).find_all_by_item_id(item.id)
    if last_purchase.count > 0
      @last_purchase_date = last_purchase.first.created_at.in_time_zone("Pacific Time (US & Canada)").strftime("%b %d @ %I:%M %p")
      @last_purchase_amount = last_purchase.first.quantity
    else
      @last_purchase_date = "None"
      @last_purchase_amount = "None"
    end
    render :partial => "item_info" #, :locals => {:base_unit => @base_unit}
  end

  def create
    @food_inventory_food_item  = FoodInventoryFoodItem.new(params[:food_inventory_food_item])
    @food_inventory_food_item.food_inventory_id = params[:food_inventory_id]
    @food_inventory = FoodInventory.find(params[:food_inventory_id])
    if @food_inventory_food_item.save
      flash[:success] = "Inventory results for #{@food_inventory_food_item.item.name} have been successfully recorded."
      redirect_to @food_inventory
    else
      flash[:warning] = "Errors prevented from being saved: #{@food_inventory_food_item.errors.first[0].to_s} #{@food_inventory_food_item.errors.first[1].humanize}."
      @page_title = "#{@food_inventory.program.name} #{@food_inventory.date}: Record inventory Results"
      render :new
    end
  end

  def destroy
    @food_inventory_food_item = FoodInventoryFoodItem.find(params[:id])
    return_path = food_inventory_path(@food_inventory_food_item.food_inventory_id)
    if @food_inventory_food_item.destroy
      flash[:success] = "#{@food_inventory_food_item.item} removed successfully from this inventory."
      redirect_to return_path
    else
      flash[:error] = "Could not remove #{@food_inventory_food_item.item}"
   end
  end

end
