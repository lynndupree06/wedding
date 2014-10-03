class AddConfirmationColumnToParties < ActiveRecord::Migration
  def change
    add_column :parties, :confirmed, :boolean
  end
end
