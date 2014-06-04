class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :last_name
      t.string :first_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.string :email

      t.timestamps
    end
  end
end
