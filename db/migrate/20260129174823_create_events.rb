class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :popularity
      t.references :user, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :slug

      t.timestamps
    end
    add_index :events, :slug, unique: true
  end
end
