class Order < ApplicationRecord
  belongs_to :campaign
  has_many :order_space
end
