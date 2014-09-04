class RsvpController < ApplicationController
  def index
  end

  def search
    code = params[:id_code]
    party_size = params[:party]
    response = params['response']

    party = Party.where(key: code).first
    guests = party.guests

    if response
      idx = 0
      params[:meal].each do |m|
        if guests[idx]
          guests[idx].meal_option = m[1]
          guests[idx].save!
        else
          Guest.create!(
              :first_name => 'Guest',
              :last_name => idx.to_s,
              :party => party,
              :meal_option => m[1]
          )
        end
        idx = idx + 1
      end
    end

    if party.nil?
      respond_to do |format|
        format.html { redirect_to rsvp_url, notice: 'Invalid Token' }
        format.json { head :no_content }
      end
    else
      party.rsvp = response
      party.size = party_size
      party.save!
    end

    @attending = response

    Emailer.send_notification_of_rsvp_email(party).deliver
  end
end
