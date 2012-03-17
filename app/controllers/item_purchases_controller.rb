class ItemPurchasesController < ApplicationController
  load_and_authorize_resource :purchase
  load_and_authorize_resource :item_purchase, :through => :purchase, :shallow => true

  def new
    @title = "New Item Purchase"
  end

  def create
    #TODO: need to warn if the type of user doesn't match the type of item'
    program_user = ProgramUser.find(current_admin_user.user_id)
    logger.debug @item_purchase.inspect
    logger.debug program_user.inspect

    if @item_purchase.item.item_type.name == program_user.job.job_type.name
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
        flash[:error] = "Could not save item"
        render :new
      end
    else
      @title = "Purchase Item"
      flash[:error] = "Item and user type mismatch"
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
