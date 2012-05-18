class MaterialItemDeliveredsController < ApplicationController

  load_and_authorize_resource :program
  load_and_authorize_resource :project #, :through => :program, :shallow => true
  load_and_authorize_resource :material_item_delivered, :through => :project, :shallow => true

  def index
  end

  def new
    @project = Project.find(params[:id])
    @title = "#{@project.program.short_name}: Material Delivery for Project: #{@project.name}"
    @material_item_delivered = MaterialItemDelivered.new
    @material_item_delivered.delivery_date = Date.today
    @material_item_delivered.quantity= 1
    @material_item_delivered.project_id= @project.id
    @item_list = Hash[@project.material_item_estimateds.map {|i| ["#{i.item.name}", i.item_id ]}]
    @user_list = Hash[@project.program.program_users.map {|u| ["#{u.admin_user.name}", u.admin_user.id ]}]
  end

  def create
    @material_item_delivered= MaterialItemDelivered.new(params[:material_item_delivered])
    @project= @material_item_delivered.project
#    logger.debug @project
    if @material_item_delivered.save
      if @project.actual_start.nil?
        @project.update_project_start(@material_item_delivered.delivery_date)
      end
      flash[:success] = "New delivered item has been successfully created."
      redirect_to @project
    else
      flash[:error] = "Errors prevented this record from being saved."
      @title = "#{@project.program.short_name}: Material Delivery for Project: #{@project.name}"
      @item_list = Hash[@project.material_item_estimateds.map {|i| ["#{i.item.name}", i.item_id ]}]
      @user_list = Hash[@project.program.program_users.map {|u| ["#{u.admin_user.name}", u.admin_user.id ]}]
      redirect_to @project
    end
  end

  def show
  end

  def destroy
    @material_item_delivered = MaterialItemDelivered.find(params[:id])
        return_path = project_path(@material_item_delivered.project_id)
        if @material_item_delivered.destroy
          flash[:success] = "This delivery was successfully deleted."

        else
          flash[:error] = "Could not remove this delivery."
        end
    redirect_to @project
  end

  def update
  end

  def edit
  end

end