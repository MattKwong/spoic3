class MaterialItemEstimatedsController < ApplicationController
  layout '_ops_layout'
  load_and_authorize_resource :project
  load_and_authorize_resource :material_item_estimated, :through => :project, :shallow => true

  def index
  end

  def new
  end

  def update
  end

  def edit
  end

  def delete
  end



  def create

    logger.debug @material_item_estimated.inspect
    if @material_item_estimated.save
      flash[:success] = "New project has been successfully created."
      redirect_to @project
    else
      flash[:warning] = "Errors prevented this record from being saved."
      @title = "Create a new project"
      render :new
    end
  end


end
