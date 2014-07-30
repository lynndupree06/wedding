class RestructureGuestList < ActiveRecord::Migration
  def change
    remove_column :guests, :address1
    remove_column :guests, :address2
    remove_column :guests, :city
    remove_column :guests, :state
    remove_column :guests, :postal_code
    remove_column :guests, :country
    remove_column :guests, :email

    add_column :parties, :address, :string
    add_column :parties, :city, :string
    add_column :parties, :state, :string
    add_column :parties, :postal_code, :string
    add_column :parties, :country, :string
    add_column :parties, :email, :string

    add_column :guests, :gender, :string
    add_column :guests, :a_b_list, :string
  end
end
