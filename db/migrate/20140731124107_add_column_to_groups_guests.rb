class AddColumnToGroupsGuests < ActiveRecord::Migration
  def change
    add_reference :groups_guests, :group
    add_reference :groups_guests, :guest
  end
end
