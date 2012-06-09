class ItemPurchasesController < ApplicationController
  load_and_authorize_resource :purchase
  load_and_authorize_resource :item_purchase, :through => :purchase, :shallow => true
  layout 'admin_layout'

  def new
    @title = "New Item Purchase"
#    @items_list = Hash[Item.all_for_program(item_purchase.purchase.program).map {|i| ["#{i.name} (base units: #{i.base_unit})", i.id]}]
    param[:filter => 0]
  end

  def edit
    @item_purchase= ItemPurchase.find(params[:id])
    @edit_flag = true
    @page_title = "Editing #{@item_purchase.item.name} in purchase #{@item_purchase.purchase.vendor.name} #{@item_purchase.purchase.date}}"
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
