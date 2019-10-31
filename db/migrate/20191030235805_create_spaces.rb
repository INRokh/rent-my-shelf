class CreateSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :spaces do |t|
      t.string :title
      t.string :description
      t.string :address
      t.string :post_code
      t.integer :price
      t.text :contact_info
      t.references :user, foreign_key: true
      t.integer :space_type
      t.integer :size

      t.timestamps
    end
  end
end
