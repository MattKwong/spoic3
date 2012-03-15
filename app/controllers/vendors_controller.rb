class VendorsController < ApplicationController

  layout '_ops_layout'

  load_and_authorize_resource :site
  load_and_authorize_resource :vendor, :through => :site, :shallow => true

  def index
    logger.debug @site.inspect
    authorize! :see_vendors_for, @site unless @site.nil?
    redirect_to site_vendors_path(current_admin_user.current_program.site) if ( @site.nil? && cannot?(:manage, Vendor))
    @title = @site.nil? ? "Vendors" : "Vendors for #{@site.name}"
    unless @site.nil?
      @menu_actions = [{:name => "New", :path => new_site_vendor_path(@site)}] if can? :create, @site.vendors.new
    end
    @vendors = @vendors.order('site_id ASC, name ASC')
  end

  def show
    @title = @vendor.name
    @menu_actions = [{:name => "Edit", :path => edit_vendor_path(@vendor)}] if can? :edit, @vendor
    @purchases = @vendor.purchases.accessible_by(current_ability)
  end

  def new
    authorize! :create, Site.find(params[:site_id]).vendors.build unless params[:site_id].nil?
    @title = "New Vendor"
  end

  def create
    if @vendor.save
      flash[:success] = "#{@vendor.name} successfully created"
      redirect_to site_vendors_path(@site)
    else
      @title = "New Vendor"
      render :new
    end
  end

  def edit
    @title = "Edit #{@vendor.name}"
    @site = @vendor.site
  end

  def update
    if(@vendor.update_attributes(params[:vendor]))
      flash[:success] = "#{@vendor.name} successfully updated"
      redirect_to vendor_path(@vendor)
    else
      @title = "Edit #{@vendor.name}"
      render :edit
    end
  end
end
