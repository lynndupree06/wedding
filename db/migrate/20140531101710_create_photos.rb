class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :desc
      t.string :category

      t.timestamps
    end
  end
end
