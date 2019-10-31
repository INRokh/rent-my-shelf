class Campaign < ApplicationRecord
    attribute :duration, :duration
    belongs_to :user
    enum size: { medium: 0, small: 1, large: 2, extra_large: 3 }
end
