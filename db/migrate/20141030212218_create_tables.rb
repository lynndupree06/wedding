class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.integer :number
      t.string :name

      t.timestamps
    end

    change_column :guests, :table, :tables
  end
end
