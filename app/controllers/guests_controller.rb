class GuestsController < AdminController
  before_action :set_guest, only: [:show, :edit, :update, :destroy]
  respond_to :json, :html

  # GET /guests
  # GET /guests.json
  def index
    # @guests = Guest.all
    respond_with do |format|
      format.to_json { Guest.all.to_json(:include => [:party, :group]) }
    end
    # render :json => Guest.all.to_json(:include => [:party, :group])
  end

  # GET /guests/1
  # GET /guests/1.json
  def show
  end

  def guests_info
    render :json => Guest.all.to_json(:include => [:party, :group])
  end

  # POST /update_guest
  def update_guest
    binding.pry
  end

  # GET /guests/new
  def new
    @guest = Guest.new
    @guest.party = Party.new
  end

  # GET /guests/1/edit
  def edit
  end

  # POST /guests
  # POST /guests.json
  def create
    @guest = Guest.new(guest_params)

    respond_to do |format|
      if @guest.save
        format.html { redirect_to @guest, notice: 'Guest was successfully created.' }
        format.json { render :show, status: :created, location: @guest }
      else
        format.html { render :new }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guests/1
  # PATCH/PUT /guests/1.json
  def update
    respond_to do |format|
      GroupsGuests.delete_all(guest_id: @guest.id);

      params[:guest][:group].to_a.each do |g|
        GroupsGuests.where(group_id: g.first, guest_id: @guest.id).first || GroupsGuests.create!(group_id: g.first, guest_id: @guest.id)
      end

      params['guest']['child'] = guest_params['child'] == '1' ? true : false;

      if @guest.update(guest_params)
        format.html { redirect_to guests_url, notice: 'Guest was successfully updated.' }
        format.json { render :show, status: :ok, location: @guest }
      else
        format.html { render :edit }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guests/1
  # DELETE /guests/1.json
  def destroy
    @guest.destroy
    respond_to do |format|
      format.html { redirect_to guests_url, notice: 'Guest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def delete_from_party
    @guest.party = nil
    @guest.save!
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_guest
    @guest = Guest.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def guest_params
    params.require(:guest).permit(:last_name, :first_name, :title, :suffix, :gender, :party_id, :group, :child)
  end
end
