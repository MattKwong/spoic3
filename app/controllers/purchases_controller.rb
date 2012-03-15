class PurchasesController < ApplicationController
  layout '_ops_layout'
  load_and_authorize_resource :program
  load_and_authorize_resource :purchase, :through => :program, :shallow => true

  def index
    redirect_to program_purchases_path(current_user.current_program) if (@program.nil? && cannot?(:manage, Purchase))
    @title = @program.nil? ? "Purchases" : "Purchases for #{@program}"
    unless @program.nil?
      @menu_actions = [{:name => "New Purchase", :path => new_program_purchase_path(@program)}]
      @purchases = @program.purchases.accessible_by(current_ability, :index).page params[:page]
    else
      @purchases = Purchase.accessible_by(current_ability, :index).page params[:page]
    end
  end

  def new
    @title = "New Purchase"
    @purchase.program = @program
    @menu_actions = [{:name => "Cancel", :path => program_purchases_path(@program)}]
    if @program.site.vendors.empty?
      flash[:notice] = "There are no vendors for #{@program.site.name}, please create one before creating a new purchase"
      redirect_to new_site_vendor_path(@program.site) 
    end
  end

  def create
    @purchase.vendor_id = params[:purchase][:vendor_id]
    @purchase.purchaser_id = params[:purchase][:purchaser_id]
    if @purchase.save
      flash[:success] = "Purchase created"
      redirect_to @purchase
    else
      @title = "New purchase"
      render :new
    end
  end

  def show
    @title = "#{@purchase.vendor.name} #{@purchase.date}"
    if( @purchase.program.food_inventories.where(:date => @purchase.date).count != 0)
      flash.now[:notice] = "An inventory already exists for this date.  Any items added to this purchase will be treated as being purchased after the inventory was taken"
    end
    @menu_actions = []
    @menu_actions << {:name => "Edit", :path => edit_purchase_path(@purchase)} if can? :edit, @purchase
    @menu_actions << {:name => "Delete", :path => purchase_path(@purchase), :method => :delete, :confirm => "Are you sure you want to delete this purchase? this action cannot be undone"} if can? :delete, @purchase
  end

  def edit
    @title = "Editing #{@purchase.vendor} #{@purchase.date}"
  end

  def update
    if @purchase.update_attributes(params[:purchase])
      flash[:success] = "Purchase updated successfully"
      redirect_to @purchase
    else
      @title = "Editing #{@purchase.vendor} #{@purchase.date}"
      render :edit
    end
  end
    
  def destroy
    if @purchase.destroy
      flash[:success] = "Purchase successfully deleted"
      redirect_to program_purchases_path(@purchase.program)
    else
      flash[:error] = "Delete failed"
      redirect_to @purchase
    end
  end
end
