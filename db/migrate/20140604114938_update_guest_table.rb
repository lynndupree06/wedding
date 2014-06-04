class UpdateGuestTable < ActiveRecord::Migration
  def change
    add_column :guests, :title, :string
    add_column :guests, :suffix, :string
    add_reference :guests, :group
  end
end
