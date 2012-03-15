class ItemPurchasesController < ApplicationController
  load_and_authorize_resource :purchase
  load_and_authorize_resource :item_purchase, :through => :purchase, :shallow => true

  def new
    @title = "New Item"
  end

  def create
    if @item_purchase.save
      respond_to do |format|
        format.html do 
          flash[:success] = "Added Item"
          redirect_to @item_purchase.purchase
        end
        format.js
      end
    else
      @title = "Purchase Item"
      render :new
    end
  end

  def destroy
    if @item_purchase.destroy
      flash[:success] = "#{@item_purchase.food_item} removed successfully"
    else
      flash[:error] = "Could not remove #{@item_purchase.food_item}"
    end
    respond_to do |format|
      format.html { redirect_to @item_purchase.purchase }
      format.js { flash.discard }
    end
  end
end
