class RemoveDurationFromCampaigns < ActiveRecord::Migration[5.2]
  def change
    remove_column :campaigns, :duration, :string
  end
end
