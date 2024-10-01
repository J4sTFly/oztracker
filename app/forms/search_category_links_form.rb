class SearchCategoryLinksForm < BaseForm
  attribute :start_date, :date
  attribute :end_date, :date
  attribute :pattern, :string

  validates :start_date, :end_date, presence: true

  def search
    return [ [], [] ] if invalid?

    prices = Price.where(created_at: [ start_date...end_date+1.day ])

    if pattern.present?
      if pattern_is_uri?
        products = Product.where(link: pattern)
        prices.where(product_id: products)
      else
        products = Product.where("name LIKE ?", "%#{sanitize_sql_like(pattern)}%")
        prices.where(product_id: products)
      end
    else
      products = Product.where(id: prices.map(&:product_id))
    end

    [ prices.group_by { |p| [ p.product_id, p.created_at.to_date ] }, products&.sort_by(&:name) ]
  end

  def new_record?
    false
  end

  private

  def pattern_is_uri?
    URI(pattern).is_a?(URI::HTTPS) if pattern.present?
  rescue URI::InvalidURIError
    false
  end

  def sanitize_sql_like(string, escape_character = "\\")
    pattern = Regexp.union(escape_character, "%", "_")
    string.gsub(pattern) { |x| [ escape_character, x ].join }
  end
end
