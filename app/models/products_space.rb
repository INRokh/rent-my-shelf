class ProductsSpace < ApplicationRecord
  belongs_to :product
  belongs_to :space
end
