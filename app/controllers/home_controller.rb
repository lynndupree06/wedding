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

  def update_party
    party_params = params.permit(:name, :email, :address, :city, :state, :postal_code, :country)
    @party = Party.find(params[:id])

    if @party.update(party_params)
      flash.keep[:notice] = 'Your details have been successfully updated. Keep a look out for your invitation!'
      redirect_to root_path
    else
      respond_to do |format|
        format.html { redirect_to user_update_path, notice: 'Something went wrong' }
        format.json { head :no_content }
      end
    end
  end

  def get_guests
    render json: { :guests => Party.find_by_key(params[:id]).guests }
  end
end
