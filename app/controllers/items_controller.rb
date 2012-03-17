class ItemsController < ApplicationController
  layout '_ops_layout'
  load_and_authorize_resource

  def index
    @title = "Items"
    @menu_actions = []
    @menu_actions << {:name => "New", :path => new_item_path} if can? :create, Item
    @items = Item.accessible_by(current_ability).joins(:item_category).order('item_categories.position ASC, name ASC').page params[:page]
  end

  def new
    @title = "New Item"
  end

  def create
    if current_admin_user.staff?
      @item.program_id = current_admin_user.program_id
    end

    if @item.save
      flash[:success] = "#{@item.name} created successfully"
      redirect_to @item
    else
      @title = "New Item"
      render :new
    end
  end

  def edit
    @title = "Editing #{@item.name}"
  end

  def update
    @item.attributes = params[:item]
    authorize! :update, @item
    if(@item.save)
      flash[:success] = "#{@item.name} successfully updated"
      redirect_to item_path(@item)
    else
      @title = "Editing #{@item.name}"
      render :edit
    end
  end

  def show
    @title = @item.name
    @menu_actions = []
    @menu_actions << {:name => "edit", :path => edit_item_path(@item)} if can? :edit, @item
    @purchases = @item.item_purchases.accessible_by(current_ability).includes(:purchase).order('purchases.date ASC')
    num = (@purchases.map {|p| p.total_base_units * p.price_per_base_unit.abs }).sum
    denom = (@purchases.map &:total_base_units).sum
    @avg_price = num / denom if denom != 0
    @inventories = @item.food_inventory_food_items.accessible_by(current_ability).includes(:food_inventory => :program).order('food_inventories.date ASC')
  end

  def destroy
    if @item.destroy
      flash[:success] = "#{@item.name} deleted"
    end
    redirect_to items_path
  end

end
