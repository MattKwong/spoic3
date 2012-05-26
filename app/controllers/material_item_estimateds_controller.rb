class MaterialItemEstimatedsController < ApplicationController
  layout 'admin_layout'
  load_and_authorize_resource :project
  #load_and_authorize_resource :material_item_estimated
  #load_and_authorize_resource :standard_item
  #load_and_authorize_resource :item

  def index
  end

  def new
    @project = Project.find(params[:id])
    @page_title = "#{@project.program.short_name}:Planned Material for Project: #{@project.name}"
    @material_item_estimated = MaterialItemDelivered.new
    @material_item_estimated.quantity= 1
    @material_item_estimated.project_id= @project.id
  end

  def update
    @material_item_estimated = MaterialItemEstimated.find(params[:id])

    if @material_item_estimated.update_attributes(params[:material_item_estimated])
      flash[:success] = "Estimated item updated successfully"
      redirect_to @material_item_estimated.project
    else
      flash[:error] = "Errors prevented this item from being being successfully updated."
      @page_title = "Update Material Estimate for #{@material_item_estimated.item.name} for project #{@material_item_estimated.project.name}."
      render :edit
    end
  end

  def edit
    @material_item_estimated = MaterialItemEstimated.find(params[:id])
    @page_title = "Update Material Estimate for #{@material_item_estimated.item.name} for project #{@material_item_estimated.project.name}."

  end

  def destroy
    @material_item_estimated = MaterialItemEstimated.find(params[:id])
    return_path = project_path(@material_item_estimated.project_id)
    if @material_item_estimated.destroy
      flash[:success] = "#{@material_item_estimated.item} removed successfully"
      redirect_to return_path
    else
      flash[:error] = "Could not remove #{@material_item_estimated.item}"
    end
  end

  def create
    @material_item_estimated = MaterialItemEstimated.new(params[:material_item_estimated])
    @project= @material_item_estimated.project
    logger.debug @project
    if @material_item_estimated.save
      flash[:success] = "New planned item has been successfully created."
      redirect_to @project
    else
      flash[:warning] = "Errors prevented this record from being saved."
      @title = "Add a new planned item."
      redirect_to @project
    end
  end

end
