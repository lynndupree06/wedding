class RemoveGroupIdInGuestTable < ActiveRecord::Migration
  def change
    remove_column :guests, :group_id
  end
end
