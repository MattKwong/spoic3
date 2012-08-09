class PurchasesController < ApplicationController
  layout 'admin_layout'
  load_and_authorize_resource :program
  load_and_authorize_resource :purchase, :through => :program, :shallow => true

  def index
    redirect_to program_purchases_path(current_user.current_program) if (@program.nil? && cannot?(:manage, Purchase))
    @page_title = @program.nil? ? "Purchases" : "Purchases for #{@program}"
    @purchases = Purchase.for_program(@program).order(:date).page params[:page]
  end

  def show_all_unaccounted
    @purchases = Purchase.all
    @page_title = 'All Purchases With Unaccounted $$'
    @purchases_with_unaccounted = Array.new
    @purchases.each do |p|
      if p.unaccounted_for_abs > 0.05
        @purchases_with_unaccounted << p
      end
    end
    @purchases_with_unaccounted
  end

  def new
    @page_title = "New Purchase"
    @purchase.program = @program
    @purchase.purchaser = current_admin_user
    if @program.site.vendors.empty?
      flash[:notice] = "There are no vendors for #{@program.site.name}, please create one before creating a new purchase"
      redirect_to new_site_vendor_path(@program.site) 
    end
    @purchase.date = Date.today
    add_breadcrumb "New Purchase", @new_purchase_path
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
    @item_type = params[:item_type]

    if @item_type.nil? || @item_type == "0"
      @items = Item.all_for_program(@purchase.program).alphabetized
    else
      @items = Item.all_for_program_by_type(@purchase.program, @item_type).alphabetized
    end
  end

  def show_budgets
    @page_title = "#{@purchase.vendor.name} #{@purchase.date}"
#    @item_type = params[:item_type]

#    if @item_type.nil? || @item_type == "0"
      @items = Item.all_for_program(@purchase.program).alphabetized
#    else
#      @items = Item.all_for_program_by_type(@purchase.program, @item_type).alphabetized
#    end
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

    if @purchase.item_purchases.any?
      flash[:error] = "Cannot delete purchase because items exist on it. Delete the individual items, then delete the purchase."
      redirect_to @purchase
    else if @purchase.destroy
      flash[:success] = "Purchase successfully deleted"
      if current_admin_user.field_staff?
        redirect_to program_purchases_path(current_admin_user.current_program)
      else
        redirect_to purchases_path
      end
    else
      flash[:error] = "Delete failed"
      redirect_to @purchase
    end
    end
  end
end
