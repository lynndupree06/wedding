class AddRsvpKeyToParty < ActiveRecord::Migration
  def change
    add_column :parties, :key, :string
  end
end
