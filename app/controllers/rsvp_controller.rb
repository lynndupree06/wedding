class RsvpController < ApplicationController
  def index
  end

  def search
    code = params[:id_code]
    party_size = params[:party]
    response = params['response']

    decoded_string = PartyEncoder.decode(code)
    party = Party.find(/[^party_id=].*/.match(decoded_string)[0].to_i)
    party.rsvp = response
    party.size = party_size
    party.save!

    @attending = response

  rescue ArgumentError => e
    respond_to do |format|
      format.html { redirect_to rsvp_url, notice: 'Invalid Token' }
      format.json { head :no_content }
    end
  end
end
