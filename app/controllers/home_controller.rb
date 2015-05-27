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

  def photos
    @photos = {}
    @photos[:engagement] = Photo.all.where(:category => 'Engagement Photos').reorder(:avatar_file_name)
    @photos[:party] = Photo.all.where(:category => 'Engagement Party').reorder(:avatar_file_name)
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
    party_params[:confirmed] = true
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
    guests = Party.find(params[:id]).guests
    rehearsal = false
    brunch = false

    guests.each do |g|
      if GroupsGuests.where(group_id: 6, guest_id: g.id).present?
        rehearsal = true
      end

      if GroupsGuests.where(group_id: 7, guest_id: g.id).present?
        brunch = true
      end
    end

    render json: {:guests => guests, :rehearsal => rehearsal, :brunch => brunch}
  end

  def get_parties
    parties = nil

    if params[:id] == 'JFK2015'
      parties = Party.all.to_json
    end

    render json: {:parties => parties}
  end

  def rsvp
    @id_code = params[:code]
    render :layout => 'application'
  end

  def search
    code = params[:id_code]
    party_size = params[:party]
    party_size_rehearsal = params[:party_rehearsal]
    party_size_brunch = params[:party_brunch]
    rsvp = params[:rsvp]
    rsvp_rehearsal = params[:rsvp_rehearsal]
    rsvp_brunch = params[:rsvp_brunch]
    party_id = params[:rsvp_party]

    party = Party.find(party_id)

    respond_to do |format|
      if code != 'JFK2015'
        flash[:error] = 'Invalid Token'
        format.html { redirect_to rsvp_url, error: 'Invalid Token' }
        format.json { head :no_content }
      else
        update_guests(party) if rsvp == '1'
        party.rsvp = rsvp == '1' ? true : false

        if rsvp_rehearsal == '1'
          party.rsvp_dinner = true
          party.size_rehearsal = party_size_rehearsal.present? ? party_size_rehearsal : party_size
        elsif party_size_rehearsal.present? && party_size_rehearsal != '0'
          party.rsvp_dinner = true
          party.size_rehearsal = party_size_rehearsal
        elsif rsvp_rehearsal == '0' && party_size_rehearsal == '0'
          party.rsvp_dinner = false
        end

        if rsvp_brunch == '1'
          party.rsvp_brunch = true
          party.size_brunch = party_size_brunch.present? ? party_size_brunch : party_size
        elsif party_size_brunch.present? && party_size_brunch != '0'
          party.rsvp_brunch = true
          party.size_brunch = party_size_brunch
        elsif rsvp_brunch == '0' && party_size_brunch == '0'
          party.rsvp_brunch = false
        end

        party.size = party_size
        party.save!

        party.reload
        Emailer.send_notification_of_rsvp_email(party).deliver

        message_start = 'Thank you for your RSVP!'
        message = rsvp == '1' ? "#{message_start} We are looking forward to seeing you at the wedding!" : "#{message_start} Sorry you are unable to attend the wedding."

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
