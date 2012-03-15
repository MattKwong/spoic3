class OpsPagesController < ApplicationController
#  load_and_authorize_resource
  layout '_ops_layout'

  def food
    @title = "SSP Food Cost Tracking"
  end

  def construction
    @title = "SSP Construction Cost Tracking"
  end

  def staff
    @title = "Staff"
  end

  def show
    if current_admin_user.food_admin?
      @title = "SSP Food Cost Tracking"
    else
      if current_admin_user.construction_admin?
        @title = "SSP Construction Cost Tracking"
      else if current_admin_user.staff?
        @title = "Site Cost Tracking"
        @tracking_area = "Construction"
        end
      end
    end
  end

end