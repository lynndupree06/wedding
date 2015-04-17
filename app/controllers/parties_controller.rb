class PartiesController < AdminController
  before_action :set_party, only: [:show, :edit, :update, :destroy]
  respond_to :json, :docx

  # GET /parties
  # GET /parties.json
  def index
    @parties = Party.all.order(:name)
    respond_with(@parties) do |format|
      format.to_json { @parties.to_json(:include => :guests) }
      format.html
    end
  end

  # GET /parties/1
  # GET /parties/1.json
  def show
    @party = Party.find(params[:id])
    respond_with(@party) do |format|
      format.to_json { @party.to_json(:include => :guests) }
      format.html
    end
  end

  # GET /parties/new
  def new
    @party = Party.new
  end

  # GET /parties/1/edit
  def edit
  end

  def tags
    @parties = Party.all
  end

  # POST /parties
  # POST /parties.json
  def create
    @party = Party.new(party_params)
    @party.key = SecureRandom.hex(3).upcase

    respond_to do |format|
      if @party.save
        format.json { render :show, status: :created, location: @party }
      else
        format.json { render json: @party.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parties/1
  # PATCH/PUT /parties/1.json
  def update
    if @party.update_attributes(party_params)
      render json: @party.as_json, status: :ok
    else
      render json: {party: @party.errors, status: :unprocessable_entity}
    end
  end

  # DELETE /parties/1
  # DELETE /parties/1.json
  def destroy
    @party.destroy
    respond_with(@party)
  end

  def save_the_date_a
    send_save_the_date_email Party.where(a_b_list: 'A'), 'A List'
  end

  def save_the_date_b
    send_save_the_date_email Party.where(a_b_list: 'B'), 'B List'
  end

  def save_the_date_special
    send_save_the_date_email Party.where("notes LIKE '%international%' AND a_b_list = 'A'"), 'International List'
  end

  def send_save_the_date_email(list, list_name)
    list.each do |p|
      if p.email.present?
        PartyNotifier.send_save_the_date_email(p).deliver
      end
    end

    respond_to do |format|
      format.html { redirect_to parties_url, notice: "Save the date emails were successfully sent to the #{list_name}." }
      format.json { head :no_content }
    end
  end

  def send_reminder_email
    Party.all.each do |p|
      PartyNotifier.send_reminder_email(p).deliver
    end

    respond_to do |format|
      format.html { redirect_to parties_url, notice: "Reminder emails were successfully sent." }
      format.json { head :no_content }
    end
  end

  def create_outer_labels
    respond_to do |format|
      format.html { redirect_to parties_path }
      format.csv { send_data Party.to_csv }
    end
  end

  def create_place_card_labels
    respond_to do |format|
      format.html { redirect_to parties_path }
      format.csv { send_data Party.place_cards_to_csv }
    end
  end

  def get_seating_chart_data
    respond_to do |format|
      format.html { redirect_to parties_path }
      format.csv { send_data Party.seating_chart_to_csv(params[:list]) }
    end
  end

  def rsvp_cards
    @parties = []
    Party.where(:a_b_list => 'A').order(:name).each do |p|
      @parties << { :qr => PartyEncoder.get_qr_code(p.key), :party => p }
    end

    respond_to do |format|
      format.docx { render docx: 'rsvp_cards' }
      format.html { render :layout => 'plain' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_party
    if params[:t]
      decoded_string = PartyEncoder.decode(params[:t])
      @party = Party.find(/[^party_id=].*/.match(decoded_string)[0].to_i)
    else
      @party = Party.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def party_params
    params.require(:party).permit(:a_b_list, :name, :email, :address, :city, :state, :postal_code,
                                  :country, :outer_envelop, :inner_envelop, :save_the_date_sent, :rsvp, :notes)
  end
end
