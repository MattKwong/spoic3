class AdminUsersController < ApplicationController
  load_and_authorize_resource

  layout '_food_layout'
  def new
    @user = AdminUser.new
  end

  def index
    @title = "Users"
    @admins = AdminUser.admin
    logger.debug @admins.inspect
    @all_staff = params[:all_staff] || false
    @staff = @all_staff ? AdminUser.staff : AdminUser.current_staff
    @menu_actions = [{:name => "New", :path => new_admin_user_path}] if can? :create, AdminUser
  end

  def create
    if @user.save
      flash[:notice] = "Successfully created user"
      redirect_to root_path
    else
      render :action => 'new'
    end
  end

  def edit
    @title = "Update Account"
  end

  def show
    @title = @user.name
    @menu_actions = [{:name => "Edit", :path => edit_admin_user_path(@user)}] if can? :edit, @user
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = 'Edit User'
      render 'edit'
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "#{@user} deleted successfully"
      redirect_to users_path( :all_staff => params[:all_staff])
    else
      @title = "Users"
      render :index
    end
  end

end
