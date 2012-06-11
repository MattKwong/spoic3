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
    @item = Item.new
    @item.program_id= @program.id if @program
  end

  def create

    if current_admin_user.staff?
      @item.program_id = current_admin_user.program_id
    end

    if @item.save
      flash[:success] = "#{@item.name} created successfully"
      redirect_to :back
    else
      flash[:error] = "A problem occurred in creating this item."
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
    num = (@item.item_purchases.map {|p| p.total_base_units * p.price_per_base_unit.scalar }).sum
    denom = (@item.item_purchases.map &:total_base_units).sum
    @avg_price = num / denom if denom != 0
    @inventories = @item.food_inventory_food_items.accessible_by(current_ability).includes(:food_inventory => :program).order('food_inventories.date ASC')
  end

  def destroy
    if @item.item_purchases.any?
      flash[:notice] = "Cannot remove this item because purchases have been made."
      else if @item.food_inventory_food_items.any?
        flash[:notice] = "Cannot remove this item because inventories for it exist"
        else if @item.material_item_delivereds.any?
          flash[:notice] = "Cannot remove this item because deliveries have been made."
             else if @item.material_item_estimateds.any?
               flash[:notice] = "Cannot remove this item because planned items exist."
                 else if @item.standard_items.any?
                    flash[:notice] = "Cannot remove this item because standard project items exist."
                      else if @item.destroy
                        flash[:success] = "#{@item.name} successfully deleted"
                         else
                        flash[:error] = "Unknown problem occurred deleting this item."
                      end
                 end
             end
        end
      end
    end

    redirect_to items_path
  end

  def show_similar_items
    words = params[:newValue].gsub(/ or /i, ",").split(" ").map(&:strip).reject(&:empty?)
    words = words.reject { |w| w.size < 4}
    @similar_items_list = []
    words.each do |w|
      list1 = Item.search_by_name(w)
      list2 = Item.search_by_name(w.first(w.size - 1))
      @similar_items_list = @similar_items_list | list1 | list2
    end
    logger.debug words.inspect
    logger.debug @similar_items_list.inspect
    #test_value1 = params[:newValue]
    #test_value2 = test_value1.first(test_value1.size - 1)
    #list1 = Item.search_by_name(test_value1)
    #list2 = Item.search_by_name(test_value2)
    #@similar_items_list = list1 & list2
    render :partial => "similar_items"
  end
end
