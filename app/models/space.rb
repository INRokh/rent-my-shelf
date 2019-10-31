class Space < ApplicationRecord
    belongs_to :user
    enum space_type: { shop: 0, cafe: 1, bar: 2, library: 3 }
    enum size: { medium: 0, small: 1, large: 2, extra_large: 3 }
end
