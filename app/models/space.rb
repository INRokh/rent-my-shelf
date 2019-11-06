class Space < ApplicationRecord
    belongs_to :user
    has_and_belongs_to_many :campaigns
    has_and_belongs_to_many :products
    has_one_attached :image
    has_many :order_spaces
    validates :title, :size, :contact_info, :post_code, :price, :space_type, :address, :products, presence: true
    enum space_type: { shop: 0, cafe: 1, bar: 2, library: 3 }
    enum size: { small: 1, medium: 0, large: 2, extra_large: 3 }

    def self.suitable_for_campaign(size, product_ids)
        where(id: 
            Space.joins(:products).select("spaces.id").where(size: size, is_active: true).group("spaces.id")
                .having("ARRAY_AGG(CAST(products.id AS integer)) @> ARRAY[?]", product_ids)
        )
    end

end
