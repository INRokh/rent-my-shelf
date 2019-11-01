class Space < ApplicationRecord
    belongs_to :user
    has_many :campaigns_spaces
    has_many :campaigns, through: :campaigns_spaces
    enum space_type: { shop: 0, cafe: 1, bar: 2, library: 3 }
    enum size: { small: 1, medium: 0, large: 2, extra_large: 3 }
end
