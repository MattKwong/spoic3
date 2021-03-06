class VendorsController < ApplicationController

  layout 'admin_layout'

  load_and_authorize_resource :site
  load_and_authorize_resource :vendor, :through => :site, :shallow => true

  def index
    authorize! :see_vendors_for, @site unless @site.nil?
    redirect_to site_vendors_path(current_admin_user.current_program.site) if ( @site.nil? && cannot?(:manage, Vendor))
    @page_title = @site.nil? ? "Vendors" : "Vendors for #{@site.name}"
    unless @site.nil?
      @menu_actions = [{:name => "New", :path => new_site_vendor_path(@site)}] if can? :create, @site.vendors.new
    end
    @vendors = @vendors.order('site_id ASC, name ASC')
  end

  def show
    @page_title = @vendor.name
    @menu_actions = [{:name => "Edit", :path => edit_vendor_path(@vendor)}] if can? :edit, @vendor
    @purchases = @vendor.purchases.accessible_by(current_ability)
  end

  def new
    authorize! :create, Site.find(params[:site_id]).vendors.build unless params[:site_id].nil?
    @page_title = "New Vendor"
  end

  def create
    if @vendor.save
      flash[:success] = "#{@vendor.name} successfully created"
      redirect_to site_vendors_path(@site)
    else
      @page_title = "New Vendor"
      render :new
    end
  end

  def edit
    @page_title = "Edit #{@vendor.name}"
    @site = @vendor.site
  end

  def update
    if(@vendor.update_attributes(params[:vendor]))
      flash[:success] = "#{@vendor.name} successfully updated"
      redirect_to vendor_path(@vendor)
    else
      @page_title = "Edit #{@vendor.name}"
      render :edit
    end
  end
 
  def destroy
    @site = current_admin_user.site_id
    #logger.debug @site
    if @vendor.purchases.any?
      flash[:error] = "Cannot delete vendor because purchases from it exist."
      redirect_to @vendor
    else
      if @vendor.destroy
        flash[:success] = "Vendor successfully deleted"
        if current_admin_user.field_staff?
          redirect_to site_vendors_path(@site)
        else
          redirect_to vendors_path
        end
      else
        flash[:error] = "Delete failed for unknown reason"
        redirect_to @vendor
      end
    end
  end
end
