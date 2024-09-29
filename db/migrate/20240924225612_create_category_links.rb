class CreateCategoryLinks < ActiveRecord::Migration[7.2]
  def change
    create_table :category_links do |t|
      t.string :url, null: false
      t.boolean :being_processed, default: false
      t.datetime :last_processed_at

      t.timestamps

      t.index :url, unique: true
    end
  end
end
