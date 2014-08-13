class AddChildrenColumnToGuestTable < ActiveRecord::Migration
  def change
    add_column :guests, :child, :boolean
  end
end
