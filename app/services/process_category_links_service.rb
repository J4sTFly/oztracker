class ProcessCategoryLinksService
  # Selectors
  NAVBAR_ITEM = ".g-pagination__list li"
  CURRENT_PAGE = ".g-pagination__list__item.g-pagination__list__item_active"
  PRODUCT_ARTICLE = "article.products__item.item.product-card:not(.pg-element-preloaded)"
  LINK = ".product-card__body a.link.product-card__link"
  PRICE = ".product-card__cost b"
  DISCOUNT = ".badge.badge-sm.badge-discount-primary"
  IMAGE = ".product-card__cover-image"
  NAME = ".product-card__title"
  AUTHOR = ".product-card__subtitle"

  attr_reader :link
  attr_accessor :products, :prices, :first_parsed_page

  def initialize(link)
    @link = link
    @products = []
    @prices = []
  end

  def call
    page_html = Faraday.get(link.url).body
    document = Nokogiri::HTML5(page_html)

    @first_parsed_page = document.at_css(CURRENT_PAGE).text.to_i
    number_of_pages = document.css(NAVBAR_ITEM).size

    parse_page(document:)
    (number_of_pages - 1).times do |page_num|
      next if page_num + 1 == first_parsed_page

      binding.pry
      page_html = Faraday.get(url_with_page(page_num + 1)).body
      parse_page(page_html:)
    end
  rescue => e
    Sidekiq.logger.error "Error: #{e}"
  end

  def parse_page(page_html: nil, document: nil)
    document ||= Nokogiri::HTML5(page_html)

    product_cards = document.css(PRODUCT_ARTICLE)
    product_cards.each do |card|
      generate_product(card)
    end

  insert_records
  end

  private

  def generate_product(card)
    product_link = card.at_css(LINK).attributes["href"].value
    image_link = card.at_css(IMAGE).attributes["src"].value
    price = card.at_css(PRICE).text.gsub(",", ".").to_f

    discount_node = card.at_css(DISCOUNT)
    discount = nil
    if discount_node
      discount = discount_node.text.to_f.abs / 100
    end

    name = card.at_css(NAME).text
    author = card.at_css(AUTHOR).text

    @products << { link: product_link, name:, author:, image_link: }
    @prices << { price:, discount: }
  end

  def url_with_page(page_num)
    default_uri = URI.parse(link.url)

    if page_num == 1
      default_uri.origin + default_uri.path
    else
      query = CGI.parse(default_uri.query).symbolize_keys
      query.merge!(page: [ page_num ])

      default_uri.origin + default_uri.path + "?#{URI.encode_www_form(query)}"
    end
  end

  def insert_records
    ids= Product.upsert_all(products, unique_by: :link).rows.flatten
    Price.insert_all(prices.map.with_index { |price, index| price.merge!(product_id: ids[index]) })
  end
end
