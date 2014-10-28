class AddRsvpToOtherEventsToPartyTable < ActiveRecord::Migration
  def change
    add_column :parties, :rsvp_dinner, :boolean
    add_column :parties, :rsvp_brunch, :boolean
  end
end
