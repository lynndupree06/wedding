class AddPartySizesForRehearsalAndBrunch < ActiveRecord::Migration
  def change
    add_column :parties, :size_rehearsal, :integer
    add_column :parties, :size_brunch, :integer
  end
end
