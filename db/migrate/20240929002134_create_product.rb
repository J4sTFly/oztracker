class CreateProduct < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :link, null: false
      t.string :name, null: false
      t.string :author
      t.integer :year_created
      t.string :image_link
      t.timestamps

      t.index :link, unique: true
    end
  end
end
