class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.string :duration
      t.integer :size
      t.integer :status
      t.string :contact_info
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end