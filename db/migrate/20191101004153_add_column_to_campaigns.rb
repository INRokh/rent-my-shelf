class AddColumnToCampaigns < ActiveRecord::Migration[5.2]
  def change
    add_column :campaigns, :end_date, :date
  end
end
