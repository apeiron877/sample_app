class PagesController < ApplicationController
  def home
    @title = "Home"
  end

  def contact
    @title = "Contact"
  end

  def
    @title = "Help"
  end

  def about
    @title = "About"
end
