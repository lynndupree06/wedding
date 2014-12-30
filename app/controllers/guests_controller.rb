class GuestsController < AdminController
  before_action :set_guest, only: [:show, :edit, :update, :destroy]
  respond_to :json, :html

  # GET /guests
  # GET /guests.json
  def index
    @guests = Guest.all.order(:last_name)
    respond_with(@guests) do |format|
      format.to_json { @guests.to_json(:include => [:party, :group]) }
    end
  end

  # GET /guests/1
  # GET /guests/1.json
  def show
    @guest = Guest.find(params[:id])
    respond_with(@guest) do |format|
      format.to_json { @guest.to_json(:include => [:party, :group]) }
    end
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
    @guest.party_id = params[:party][:id]

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
      if params[:group].present?
        GroupsGuests.delete_all(guest_id: @guest.id)

        params[:group].each do |g|
          if g['selected']
            groupId = Group.where(name: g['name']).ids
            GroupsGuests.where(group_id: groupId[0], guest_id: @guest.id).first || GroupsGuests.create!(group_id: groupId[0], guest_id: @guest.id)
          end
        end
      end

      if @guest.update(guest_params)
        @guest.party_id = params[:party][:id]
        @guest.save!

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
    params.require(:guest).permit(:last_name, :first_name, :title, :suffix, :gender, :party, :group, :child, :group)
  end
end
