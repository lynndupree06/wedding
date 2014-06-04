class UpdateGuestTableWithPartyId < ActiveRecord::Migration
  def change
    add_reference :guests, :party
  end
end
