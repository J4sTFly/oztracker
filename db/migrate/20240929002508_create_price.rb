class CreatePrice < ActiveRecord::Migration[7.2]
  def change
    create_table :prices do |t|
      t.belongs_to :product, index: true, foreign_key: true
      t.float :price, null: false
      t.float :discount
      t.timestamps
    end
  end
end
