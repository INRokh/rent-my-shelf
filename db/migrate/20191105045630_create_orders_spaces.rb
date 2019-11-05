class CreateOrdersSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :orders_spaces do |t|
      t.integer :price
      t.references :order, foreign_key: true
      t.references :space, foreign_key: true

      t.timestamps
    end
  end
end
