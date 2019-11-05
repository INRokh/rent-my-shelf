class Order < ApplicationRecord
  belongs_to :campaign
  has_one :campaign
  has_many :order_spaces
end
