class AddMealsToParty < ActiveRecord::Migration
  def change
    add_column :parties, :meals, :string
  end
end
