class UpdatePartyGuestTables < ActiveRecord::Migration
  def change
    add_column :parties, :a_b_list, :string
    remove_column :guests, :a_b_list
  end
end
