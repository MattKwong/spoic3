 class StandardItemsController < ApplicationController
  layout '_ops_layout'
  load_and_authorize_resource :project
  load_and_authorize_resource :material_item_estimated, :through => :project, :shallow => true
  load_and_authorize_resource :standard_item

  def index
  end

  def add
  end

  def show
    #logger.debug @project.inspect
    @standard_item = StandardItem.find(params[:id])
  end

  def new
  end

  def update
  end

  def edit
  end

  def destroy

  end



  def create
  end


end
