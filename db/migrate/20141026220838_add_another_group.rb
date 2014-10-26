class AddAnotherGroup < ActiveRecord::Migration
  def change
    Group.create!(:name => 'Rehearsal Dinner')
  end
end
