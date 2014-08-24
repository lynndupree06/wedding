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

  def registry
    render :layout => 'application'
  end

  def user_update
    if params[:t]
      party = PartyEncoder.decode(params[:t])
      @party = Party.find(/[0-9]+/.match(party).to_s)
      render :layout => 'application'
    else
      redirect_to root_path
    end
  end
end
