class CreateProductsSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :products_spaces do |t|
      t.references :product, foreign_key: true
      t.references :space, foreign_key: true

      t.timestamps
    end
  end
end
