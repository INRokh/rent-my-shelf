class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :strip_id
      t.integer :total
      t.references :campaign, foreign_key: true

      t.timestamps
    end
  end
end
