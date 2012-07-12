class ItemPurchasesController < ApplicationController
  helper_method :sort_column, :sort_direction
  load_and_authorize_resource :purchase
  load_and_authorize_resource :item_purchase, :through => :purchase, :shallow => true
  layout 'admin_layout'

  def new
    @title = "New Item Purchase"
#    @items_list = Hash[Item.all_for_program(item_purchase.purchase.program).map {|i| ["#{i.name} (base units: #{i.base_unit})", i.id]}]
    @items = Item.all_for_program(item_purchase.purchase.program)

  end

  def edit
    @item_purchase= ItemPurchase.find(params[:id])
    #logger.debug @item_purchase.inspect
    @items = Item.find_all_by_id(@item_purchase.item_id)
    #logger.debug @items.inspect
    @edit_flag = true
    @page_title = "Editing #{@item_purchase.item.name} in purchase #{@item_purchase.purchase.vendor.name} #{@item_purchase.purchase.date}}"
  end

  def index
#    redirect_to program_purchases_path(current_user.current_program) if (@program.nil? && cannot?(:manage, Purchase))
    @program = Program.find(params[:program_id])
    @budget_type = BudgetItemType.find(params[:id])
    @page_title = "#{@budget_type.name} Budget Purchases - #{@program.site.name}"
    @item_purchases = ItemPurchase.by_budget_line_type(@budget_type.id).for_program(@program).order(sort_column + ' ' + sort_direction).page params[:page]
  end

  def update
    if @item_purchase.update_attributes(params[:item_purchase])
      flash[:success] = "Purchase item updated successfully"
      redirect_to @item_purchase.purchase
    else
      @page_title = "Editing #{@item_purchase.item.name} in purchase #{@item_purchase.purchase.vendor.name} #{@item_purchase.purchase.date}}"
      render :edit
    end
  end


  def create
    @item_type = params[:item_type]
      if @item_purchase.save
        flash[:success] = "Successfully added item!"
        redirect_to purchase_path(:id => @purchase.id, :item_type => @item_type )
      else
        @title = "Purchase Item"
        flash[:error] = @item_purchase.errors.first[1].humanize
#        @purchase
        render @purchase
      end
  end

  def destroy
    return_path = purchase_path(:id => @item_purchase.purchase_id)
    if @item_purchase.destroy
      flash[:success] = "#{@item_purchase.item} removed successfully"
      redirect_to return_path
    else
      flash[:error] = "Could not remove #{@item_purchase.item}"
    end
  end

private
  def sort_column
    params[:sort] || "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
end
