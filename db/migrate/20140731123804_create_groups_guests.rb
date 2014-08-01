class CreateGroupsGuests < ActiveRecord::Migration
  def change
    create_table :groups_guests do |t|

      t.timestamps
    end
  end
end
