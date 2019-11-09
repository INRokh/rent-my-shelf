class Product < ApplicationRecord
  has_and_belongs_to_many :campaigns
  has_and_belongs_to_many :spaces
end
