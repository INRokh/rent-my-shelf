class Space < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :campaigns
  has_and_belongs_to_many :products
  has_one_attached :image
  has_many :order_spaces
  validates :title, :size, :contact_info, :post_code, :price, :space_type, :address, :products, presence: true
  enum space_type: { shop: 0, cafe: 1, bar: 2, library: 3 }
  enum size: { small: 1, medium: 0, large: 2, extra_large: 3 }

  def self.suitable_for_campaign(size, product_ids, from, to)
    size_id = sizes[size]
    query = <<~"RAW_SQL"
      WITH suitable_spaces AS (
        SELECT spaces.id
        FROM spaces INNER JOIN products_spaces
            ON spaces.id = products_spaces.space_id
        WHERE spaces.size = ? AND spaces.is_active IS TRUE
        GROUP BY spaces.id
        HAVING ARRAY_AGG(CAST(products_spaces.product_id AS integer)) @> ARRAY[?]
      ),
      overlapping_spaces AS (
        SELECT suitable_spaces.id
        FROM suitable_spaces INNER JOIN campaigns_spaces
          ON suitable_spaces.id = campaigns_spaces.space_id
        INNER JOIN campaigns
          ON campaigns_spaces.campaign_id = campaigns.id
        WHERE (campaigns.start_date, campaigns.end_date)
          OVERLAPS (DATE ?, DATE ?)
        GROUP BY suitable_spaces.id
      )

      SELECT spaces.*
      FROM suitable_spaces
      INNER JOIN spaces ON suitable_spaces.id = spaces.id 
      WHERE NOT EXISTS (
        SELECT overlapping_spaces.id
        FROM overlapping_spaces
        WHERE suitable_spaces.id = overlapping_spaces.id
      )
    RAW_SQL
    find_by_sql([query, size_id, product_ids, from, to])
  end

  def self.suitable_for_campaign_in_area(size, product_ids, from, to, post_code)
    size_id = sizes[size]
    query = <<~"RAW_SQL"
      WITH suitable_spaces AS (
        SELECT spaces.id
        FROM spaces INNER JOIN products_spaces
            ON spaces.id = products_spaces.space_id
        WHERE spaces.size = :size AND spaces.is_active IS TRUE AND
          spaces.post_code = :post_code
        GROUP BY spaces.id
        HAVING ARRAY_AGG(CAST(products_spaces.product_id AS integer)) @> ARRAY[:product_ids]
      ),
      overlapping_spaces AS (
        SELECT suitable_spaces.id
        FROM suitable_spaces INNER JOIN campaigns_spaces
          ON suitable_spaces.id = campaigns_spaces.space_id
        INNER JOIN campaigns
          ON campaigns_spaces.campaign_id = campaigns.id
        WHERE (campaigns.start_date, campaigns.end_date)
          OVERLAPS (DATE :date_from, DATE :date_to)
        GROUP BY suitable_spaces.id
      )

      SELECT spaces.*
      FROM suitable_spaces
      INNER JOIN spaces ON suitable_spaces.id = spaces.id 
      WHERE NOT EXISTS (
        SELECT overlapping_spaces.id
        FROM overlapping_spaces
        WHERE suitable_spaces.id = overlapping_spaces.id
      )
    RAW_SQL
    find_by_sql([query, :size => size_id,
      :post_code => post_code, :product_ids => product_ids,
      :date_from => from, :date_to => to])
  end
end
