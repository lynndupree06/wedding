class RsvpController < ApplicationController
  def index
  end

  def search
    code = params[:id_code]
    party_size = params[:party]
    meal = params[:meal]
    response = params['response']

    party = Party.where(key: code)

    if party.empty?
      respond_to do |format|
        format.html { redirect_to rsvp_url, notice: 'Invalid Token' }
        format.json { head :no_content }
      end
    else
      party.update_all(rsvp: response, size: party_size)
    end

    @attending = response
  end
end
