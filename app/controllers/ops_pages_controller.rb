class OpsPagesController < ApplicationController
  layout '_food_layout'

  def food
    @page_title = "SSP Food Tracking Application"
    @title = "SSP Food"
  end

  def construction
    @title = "CTAB"
  end

end