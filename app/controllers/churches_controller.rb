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
        redirect_to myssp_path(Liaison.find_by_church_id(@church.id).id)
      else
        flash[:error] = "Update of church information failed."
        render 'edit'
      end
  end
end


