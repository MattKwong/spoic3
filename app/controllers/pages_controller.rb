class PagesController < ApplicationController
  def home
      @title = "Welcome"
  end

  def admin
    @title = "Administrative Center"
  end

  def food
    @title = "Tabatha"
  end

  def construction
    @title = "CTAB"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end


end
