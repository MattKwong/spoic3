class ItemsController < ApplicationController
  layout 'admin_layout'
  load_and_authorize_resource

  def index
    @page_title = "Items"

    if current_admin_user.admin? || current_admin_user.sd?
      @items = Item.accessible_by(current_ability).joins(:item_category).order('item_categories.position ASC, name ASC').page params[:page]
    else if current_admin_user.construction_admin? || current_admin_user.construction?
           @items = Item.materials.accessible_by(current_ability).joins(:item_category).order('item_categories.position ASC, name ASC').page params[:page]
         else if current_admin_user.food_admin? || current_admin_user.cook?
           @items = Item.food.accessible_by(current_ability).joins(:item_category).order('item_categories.position ASC, name ASC').page params[:page]
         end
      end
    end
  end

  def new
    @page_title = "New Item"
  end

  def create
    if current_admin_user.staff?
      @item.program_id = current_admin_user.program_id
    end

    if @item.save
      flash[:success] = "#{@item.name} created successfully"
      redirect_to :back
    else
      @page_title = "New Item"
      render :new
    end
  end

  def edit
    @page_title = "Editing #{@item.name}"

  end

  def update
    @item.attributes = params[:item]
 #   authorize! :update, @item
    if(@item.save)
      flash[:success] = "#{@item.name} successfully updated"
      redirect_to items_path
    else
      @page_title = "Editing #{@item.name}"
      render :edit
    end
  end

  def show
    @page_title = @item.name
    #@menu_actions = []
    #@menu_actions << {:name => "edit", :path => edit_item_path(@item)} if can? :edit, @item
    #@purchases = @item.item_purchases.accessible_by(current_ability).includes(:purchase).order('purchases.date ASC')
    num = (@item.item_purchases.map {|p| p.total_base_units * p.price_per_base_unit.abs }).sum
    denom = (@item.item_purchases.map &:total_base_units).sum
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
