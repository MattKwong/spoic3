class ItemPurchasesController < ApplicationController
  load_and_authorize_resource :purchase
  load_and_authorize_resource :item_purchase, :through => :purchase, :shallow => true
  layout '_ops_layout'

  def new
    @title = "New Item Purchase"
  end

  def create

       if @item_purchase.save
        respond_to do |format|
          format.html do
            flash[:success] = "Added Item"
            redirect_to purchase_path(@purchase)
            end
#          format.js
        end
      else
        @title = "Purchase Item"
        flash[:error] = "Could not save item"
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
