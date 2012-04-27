class MaterialItemEstimatedsController < ApplicationController
  layout '_ops_layout'
  load_and_authorize_resource :project
  #load_and_authorize_resource :material_item_estimated
  #load_and_authorize_resource :standard_item
  #load_and_authorize_resource :item

  def index
  end

  def new
  end

  def update
  end

  def edit
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
    @material_item_estimated.project_id = @project.id
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
