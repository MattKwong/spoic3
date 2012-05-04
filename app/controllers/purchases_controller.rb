class PurchasesController < ApplicationController
  layout 'admin_layout'
  load_and_authorize_resource :program
  load_and_authorize_resource :purchase, :through => :program, :shallow => true

  def index
    redirect_to program_purchases_path(current_user.current_program) if (@program.nil? && cannot?(:manage, Purchase))
    @page_title = @program.nil? ? "Purchases" : "Purchases for #{@program}"
  end

  def new
    @page_title = "New Purchase"
    @purchase.program = @program
    if @program.site.vendors.empty?
      flash[:notice] = "There are no vendors for #{@program.site.name}, please create one before creating a new purchase"
      redirect_to new_site_vendor_path(@program.site) 
    end
    @purchase.date = Date.today
  end

  def create
    @purchase.vendor_id = params[:purchase][:vendor_id]
    @purchase.purchaser_id = params[:purchase][:purchaser_id]
    if @purchase.save
      flash[:success] = "Purchase created"
      redirect_to @purchase
    else
      @page_title = "New purchase"
      render :new
    end
  end

  def show
    @page_title = "#{@purchase.vendor.name} #{@purchase.date}"
    if( @purchase.program.food_inventories.where(:date => @purchase.date).count != 0)
      flash.now[:notice] = "An inventory already exists for this date.  Any items added to this purchase will be treated as being purchased after the inventory was taken"
    end
  end

  def edit
    @page_title = "Editing #{@purchase.vendor} #{@purchase.date}"
  end

  def update
    if @purchase.update_attributes(params[:purchase])
      flash[:success] = "Purchase updated successfully"
      redirect_to @purchase
    else
      @page_title = "Editing #{@purchase.vendor} #{@purchase.date}"
      render :edit
    end
  end
    
  def destroy
    if @purchase.destroy
      flash[:success] = "Purchase successfully deleted"
      if current_admin_user.field_staff?
        redirect_to program_purchases_path(current_user.current_program)
      else
        redirect_to purchases_path
      end
    else
      flash[:error] = "Delete failed"
      redirect_to @purchase
    end
  end
end
