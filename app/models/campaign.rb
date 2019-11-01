class Campaign < ApplicationRecord
    belongs_to :user
    has_many :campaigns_spaces
    has_many :spaces, through: :campaigns_spaces
    has_many :campaigns_products
    has_many :products, through: :campaigns_products
    enum size: { small: 1, medium: 0, large: 2, extra_large: 3 }
end
