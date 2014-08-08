class UpdatePartyTable < ActiveRecord::Migration
  def change
    add_column :parties, :rsvp, :boolean
    add_column :parties, :size, :integer
  end
end
