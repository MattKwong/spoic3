class FoodInventoriesController < ApplicationController
  layout 'admin_layout'

  load_and_authorize_resource :program
  load_and_authorize_resource :food_inventory, :through => :program, :shallow => true

  def index
    authorize! :see_food_inventories_for, @program unless @program.nil?
    redirect_to program_food_inventories_path(current_admin_user.current_program) if ( @program.nil? && cannot?(:manage, FoodInventory))
    @page_title = @program.nil? ? "Food Inventories" : "Food Inventories for #{@program}"
    unless @program.nil?
      @menu_actions = [{:name => "New", :path => new_program_food_inventory_path(@program) }] if can? :create, FoodInventory
    end
    @food_inventories = @food_inventories.order('date ASC').page params[:page]
  end

  def show
    @page_title = "#{@food_inventory.date} Food Inventory"
    @menu_actions = []
    @menu_actions << {:name => "Edit", :path => edit_food_inventory_path(@food_inventory) } if can? :edit, @food_inventory
    @menu_actions << {:name => "Delete",
      :path => food_inventory_path(@food_inventory), 
      :method => :delete, 
      :confirm => "Are you sure you want to delete this inventory? This cannot be undone." } if can? :destroy, @food_inventory
    if @food_inventory.program.purchases.where(:date => @food_inventory.date).count != 0
      flash.now[:notice] = "There is a purchase recorded for this date.  This inventory will be treated as before any purchases on #{@food_inventory.date}"
    end
  end

  def new
    @page_title = "New Food Inventory"
    @food_inventory.date = Date.today
  end

  def create
    if @food_inventory.save
      flash[:success] = "Food inventory created successfully"
      redirect_to @food_inventory
    else
      @page_title = "New Food Inventory"
      render :new
    end
  end

  def edit
    @page_title = "Editing #{@food_inventory.date} Food Inventory"
    @program = @food_inventory.program
    (@program.purchased_food_items - @food_inventory.items).each do
        |food_item| @food_inventory.food_inventory_food_items.build(:item_id => food_item.id).update_in_inventory
    end
  end

  def update

    if @food_inventory.update_attributes(params[:food_inventory])
      flash[:success] = "Food inventory updated successfully"
      redirect_to @food_inventory
    else
      @page_title = "Editing #{@food_inventory.date} Food Inventory"
      render :edit
    end
  end
      
  def destroy
    if @food_inventory.destroy
      flash[:success] = "Inventory deleted successfully"
      redirect_to program_food_inventories_path(@food_inventory.program)
    else
      flash[:error] = "Food Inventory deletion failed"
      redirect_to @food_inventory
    end
  end

  def inventory_prep_report
    @page_title = "Inventory Prep Report As Of #{Time.now.in_time_zone("Pacific Time (US & Canada)").strftime("%b %d @ %I:%M %p")}"
    @inventory_list = Array.new
    @program = Program.find(params[:program_id])
    Item.food.each do |i|
      inventories = FoodInventoryFoodItem.for_program(@program).find_all_by_item_id(i.id)#.order('food_inventories.date ASC')
  #   purchases = ItemPurchase.joins(:purchases).where('item_id = ? and purchases.program_id = ?', i.id, @program.id)
      purchases = ItemPurchase.for_program(@program).find_all_by_item_id(i.id)
      if inventories.any? || purchases.any? #Either exist
        list_item = Hash.new
        list_item.store(:item_name, i.name)
        list_item.store(:item_description, i.description)
        list_item.store(:base_unit, i.base_unit)

      #only purchases - we set the purchase info only
        if purchases.any? # && !inventories.any?
          list_item.store(:last_purchased_on, purchases.last.purchase.date)
          list_item.store(:amount_purchased, (purchases.last.quantity.to_s + ' of ' + purchases.last.size))
        end
        if inventories.any? # && !purchases.any?
        #Only inventory - set the inventory information, set the purchase info to 'none', Weekly consumption
        #is blank and expected amounts are last inventoried amount
          list_item.store(:last_inventory_date, inventories.last.food_inventory.date)
          list_item.store(:last_inventory_amount, inventories.last.quantity)
          list_item.store(:maximum_expected, inventories.last.quantity)
#          list_item.store(:purchased_since_last_inventory, i.purchased_for_program(@program, inventories.last.food_inventory.date, Time.now.to_date))
        end
        if inventories.any? && purchases.any?
        #Both exist. Inventory and purchase fields were already set above. All we need to calculate is
        #weekly consumption and expected amount
          purchases_since_start = i.program_purchases(@program)
          weeks_since_start = ((Time.now.to_date) - @program.first_session_start)/7
          if weeks_since_start != 0
            ave_consumption = (purchases_since_start - inventories.last.in_base_units)/weeks_since_start
            list_item.store(:weekly_consumption, ave_consumption )
          end
          purchases_since_last_inventory = i.purchases_between(@program, inventories.last.food_inventory.date, Time.now.to_date)
          logger.debug purchases_since_last_inventory.inspect
          purchased_since_last_inventory = (purchases_since_last_inventory.map &:total_base_units).sum
          list_item.store(:maximum_expected, inventories.last.in_base_units + purchased_since_last_inventory)
          list_item.store(:purchased_since_last_inventory, purchased_since_last_inventory)
        end

        @inventory_list << list_item
      end
    end

    @inventory_list_values = Array.new

    @inventory_list.each do |i|
      temp = Array.new
      temp[0] = i[:item_name]
      temp[1] = i[:item_description]
      temp[2] = i[:base_unit]
      @inventory_list_values << temp
      logger.debug @inventory_list_values.inspect
      #@inventory_list_values[j, 1] = i[:item_description]
      #@inventory_list_values[j, 2] = i[:base_unit]
      logger.debug @inventory_list_values.inspect

    end
    logger.debug @inventory_list_values.inspect
    render "inventory_prep_report"
  end
end
