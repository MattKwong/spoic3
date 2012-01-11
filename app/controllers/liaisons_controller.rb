class LiaisonsController < ApplicationController
  def create_user
    liaison = Liaison.find(params[:id])
    logger.debug liaison.inspect
    redirect_to admin_liaison_path(liaison.id)
  end
end