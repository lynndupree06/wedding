class RsvpController < ApplicationController
  def index
  end

  def search
    code = params[:id_code]
    party_size = params[:party]
    response = params['response']

    idx = 1
    meal = {}
    while params[:meal][idx.to_s].present? do
      meal[idx] = params[:meal][idx.to_s]
      idx = idx + 1
    end

    party = Party.where(key: code).first

    if party.nil?
      respond_to do |format|
        format.html { redirect_to rsvp_url, notice: 'Invalid Token' }
        format.json { head :no_content }
      end
    else
      party.rsvp = response
      party.size = party_size
      party.meals = meal
      # party.save!
    end

    @attending = response

    Emailer.send_notification_of_rsvp_email(party).deliver
  end
end
