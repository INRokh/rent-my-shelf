class CampaignsProduct < ApplicationRecord
  belongs_to :product
  belongs_to :campaign
end
