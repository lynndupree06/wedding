class RefactorPartiesAndGuests < ActiveRecord::Migration
  def change
    add_column :guests, :meal_option, :string
    add_column :guests, :table, :integer
    remove_column :parties, :meals
  end
end
