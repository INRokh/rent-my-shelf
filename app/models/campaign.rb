class Campaign < ApplicationRecord
    belongs_to :user
    has_one :order
    has_and_belongs_to_many :spaces
    has_and_belongs_to_many :products
    enum size: { small: 0, medium: 1, large: 2, extra_large: 3 }
    enum status: { new_campaign: 0, in_progress: 1, finished: 2 }
end
