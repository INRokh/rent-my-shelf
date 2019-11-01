class CreateCampaignsSpaces < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns_spaces do |t|
      t.references :campaign, foreign_key: true
      t.references :space, foreign_key: true

      t.timestamps
    end
  end
end
