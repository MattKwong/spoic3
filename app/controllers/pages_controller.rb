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

  def groups
    @title = "Group Manager"
  end

end
