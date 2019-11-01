class Product < ApplicationRecord
    has_many :products_spaces
    has_many :spaces, through: :products_spaces
    has_many :campaigns_products
    has_many :campaigns, through: :campaigns_products
end
