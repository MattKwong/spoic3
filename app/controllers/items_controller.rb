class ItemsController < ApplicationController
  layout 'admin_layout'
  load_and_authorize_resource

  def index
    @page_title = "Items"
    if session[:program]
      add_breadcrumb Program.find(session[:program]).name, program_path(session[:program])
    end
    if current_admin_user.program_id > 0
      @program = Program.find(current_admin_user.program_id)
    end

    if params[:item_type].nil? || params[:item_type] == "0"
      if @program
        @items = Item.all_for_program(@program).page params[:page]
      else
        @items = Item.alphabetized.page params[:page]
      end
    else
      if params[:item_type] == '41' #Tracked materials
        if @program
          @items = Item.materials.tracked.page params[:page]
        else
          @items = Item.materials.tracked.alphabetized.page params[:page]
        end
      else
        if params[:item_type] == '42' #Untracked materials
          if @program
            @items = Item.materials.untracked.page params[:page]
          else
            @items = Item.materials.untracked.alphabetized.page params[:page]
          end
        else
          if @program
            @items = Item.all_for_program_by_type(@program, params[:item_type]).page params[:page]
          else
            @items = Item.all_by_item_type(params[:item_type]).alphabetized.page params[:page]
          end
        end
      end
    end
    #  current_admin_user.admin?
    #    @items = Item.accessible_by(current_ability).page params[:page]
    #  else if current_admin_user.sd?
    #    @items = Item.accessible_by(current_ability).page params[:page]
    #  else if current_admin_user.construction_admin? || current_admin_user.construction?
    #    @items = Item.materials.accessible_by(current_ability).page params[:page]
    #  else if current_admin_user.food_admin? || current_admin_user.cook?
    #    @items = Item.food.accessible_by(current_ability).page params[:page]
    #  end
    #  end
    #  end
    #  end
    #else
    #  if current_admin_user.admin?
    #    @items = Item.accessible_by(current_ability).where('item_type_id = ?', params[:item_type]).page params[:page]
    #  else if  current_admin_user.sd?
    #    @items = Item.accessible_by(current_ability).all_for_program_by_type(@program, params[:item_type]).page params[:page]
    #  else if current_admin_user.construction_admin? || current_admin_user.construction?
    #    @items = Item.materials_and_tools.accessible_by(current_ability).all_for_program_by_type(@program, params[:item_type]).page params[:page]
    #  else if current_admin_user.food_admin? || current_admin_user.cook?
    #    @items = Item.food.accessible_by(current_ability).all_for_program_by_type(@program, params[:item_type]).page params[:page]
    #  end
    #  end
    #  end
    #  end
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
    params[:item].delete("base_unit")
    @item.attributes = params[:item]

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
    if session[:program]
      add_breadcrumb Program.find(session[:program]).name, program_path(session[:program])
    end
    if current_admin_user.program_id > 0
      @program = Program.find(current_admin_user.program_id)
    end
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
    if current_admin_user.program_id > 0
      @program = Program.find(current_admin_user.program_id)
    end

    words = params[:newValue].gsub(/ or /i, ",").split(" ").map(&:strip).reject(&:empty?)
    words = words.reject { |w| w.size < 4}
    @similar_items_list = []
    words.each do |w|
      if @program
        list1 = Item.all_for_program(@program).search_by_name(w)
        list2 = Item.all_for_program(@program).search_by_name(w.first(w.size - 1))
      else
        list1 = Item.search_by_name(w)
        list2 = Item.search_by_name(w.first(w.size - 1))
      end
      @similar_items_list = @similar_items_list | list1 | list2
    end
    render :partial => "similar_items"
  end
end
