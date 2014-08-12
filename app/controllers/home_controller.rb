class HomeController < ApplicationController
  def index
    render :layout => 'home'
  end

  def wedding
    render :layout => 'application'
  end

  def our_story
    render :layout => 'application'
  end

  def reception
    render :layout => 'application'
  end

  def wedding_party
    render :layout => 'application'
  end

  def guest_info
    render :layout => 'application'
  end
end
