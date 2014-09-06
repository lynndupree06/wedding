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
    render json: {:guests => Party.find_by_key(params[:id]).guests}
  end

  def rsvp
    render :layout => 'application'
  end

  def search
    code = params[:id_code]
    party_size = params[:party]
    response = params['response']

    party = Party.where(key: code).first

    respond_to do |format|
      if party.nil?
        flash[:error] = 'Invalid Token'
        format.html { redirect_to rsvp_url, error: 'Invalid Token' }
        format.json { head :no_content }
      else
        update_guests(party) if response
        party.rsvp = response == '1' ? true : false
        party.size = party_size
        party.save!

        party.reload
        Emailer.send_notification_of_rsvp_email(party).deliver

        message_start = 'Thank you for your RSVP!'
        message = response == '1' ? "#{message_start} We are looking forward to seeing you at the wedding!" : "#{message_start} Sorry you are unable to attend the wedding."

        format.html { redirect_to root_url, notice: message }
        format.json { head :no_content }
      end
    end
  end

  def update_guests(party)
    guests = party.guests
    idx = 0
    params[:meal].each do |m|
      first_name = nil
      last_name = nil

      if params['guest'] && params['guest'][idx.to_s]
        first_name = params['guest'][idx.to_s].scan(/.*\s/)[0].strip
        last_name = params['guest'][idx.to_s].scan(/\s.*/)[0].strip
      end

      if guests[idx]
        guests[idx].meal_option = m[1]
        guests[idx].first_name = first_name if first_name.present?
        guests[idx].last_name = last_name if last_name.present?
        guests[idx].save!
      else
        Guest.create!(
            :first_name => first_name ? first_name : 'Guest',
            :last_name => last_name ? last_name : (idx + 1).to_s,
            :party => party,
            :meal_option => m[1]
        )
      end
      idx = idx + 1
    end

    while guests[idx].present?
      if guests[idx].first_name.include?('Guest')
        guests[idx].destroy
      end
      idx = idx + 1
    end
  end
end
