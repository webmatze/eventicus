class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :street
      t.string :zip
      t.string :url
      t.string :email
      t.string :phone
      t.text :description
      t.decimal :latitude
      t.decimal :longitude
      t.references :city, null: false, foreign_key: true
      t.string :slug

      t.timestamps
    end
    add_index :locations, :slug, unique: true
  end
end
