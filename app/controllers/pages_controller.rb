class PagesController < ApplicationController
  layout 'admin_layout'
  def home
    @page_title = "SSP Information Center"
    @title = "Welcome"
  end

  def contact
    @page_title = "SSP Information Center"
    @title = "Contact"
  end

  def about
    @page_title = "SSP Information Center"
    @title = "About"
  end

  def help
    @page_title = "SSP Information Center"
    @title = "Help"
  end

end
