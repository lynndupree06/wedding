class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :name
      t.string :outer_envelop
      t.string :inner_envelop

      t.timestamps
    end
  end
end
