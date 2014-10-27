class AddSundyBrunchGroup < ActiveRecord::Migration
  def change
    Group.create!(:name => 'Sunday Brunch')
  end
end
