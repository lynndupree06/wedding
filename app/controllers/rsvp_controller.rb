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
              :last_name => (idx + 1).to_s,
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

    respond_to do |format|
      if party.nil?
          format.html { redirect_to rsvp_url, error: 'Invalid Token' }
          format.json { head :no_content }
      else
        party.rsvp = response == '1' ? true : false
        party.size = party_size
        party.save!

        party.reload
        Emailer.send_notification_of_rsvp_email(party).deliver

        messageStart = 'Thank you for your RSVP!'
        message = response == '1' ? "#{messageStart} We are looking forward to seeing you at the wedding!" : "#{messageStart} Sorry you are unable to attend the wedding."

        format.html { redirect_to root_url, notice: message }
        format.json { head :no_content }
      end
    end
  end
end
