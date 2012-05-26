class ItemPurchasesController < ApplicationController
  load_and_authorize_resource :purchase
  load_and_authorize_resource :item_purchase, :through => :purchase, :shallow => true
  layout '_ops_layout'

  def new
    @title = "New Item Purchase"
    @items_list = Hash[Item.all_for_program(item_purchase.purchase.program).map {|i| ["#{i.name} (base units: #{i.base_unit})", i.id]}]
    logger.debug @items_list.inspect
  end

  def create
      if @item_purchase.save
        flash[:success] = "Added Item"
        redirect_to purchase_path(@purchase)
      else
        @title = "Purchase Item"
        flash[:error] = @item_purchase.errors.first[1].humanize
        @purchase
        redirect_to @purchase
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
#    respond_to do |format|
#      format.html { redirect_to @purchase }
##      format.js { flash.discard }
#    end
  end
end
