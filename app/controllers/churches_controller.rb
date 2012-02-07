require 'csv'

class ChurchesController < ApplicationController
  load_and_authorize_resource
  layout 'admin_layout'

  def edit
    @page_title = "Edit Church Information"
  end

  def update
    if @church.update_attributes(params[:church])
      flash[:success] = "Successful update of church information"
    else
      flash[:error] = "Update of church information failed."
    end
    redirect_to myssp_path(current_admin_user.liaison_id)
  end
end


