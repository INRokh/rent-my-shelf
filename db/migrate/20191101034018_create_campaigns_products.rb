class CreateCampaignsProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns_products do |t|
      t.references :product, foreign_key: true
      t.references :campaign, foreign_key: true

      t.timestamps
    end
  end
end
