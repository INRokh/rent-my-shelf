class OrdersSpace < ApplicationRecord
  belongs_to :order
  belongs_to :space
  has_many :spaces
  has_one :order
end
