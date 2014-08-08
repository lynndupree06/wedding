class UpdatePartiesTable < ActiveRecord::Migration
  def change
    add_column :parties, :save_the_date_sent, :boolean
    add_column :parties, :notes, :string
  end
end
