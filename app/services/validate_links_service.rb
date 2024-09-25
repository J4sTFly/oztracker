class ValidateLinksService
  attr_accessor :urls, :category_links

  NOT_FOUND_CODE = 404

  def initialize(urls)
    @urls = urls
  end

  def call
    instantiate_links
    current_datetime = DateTime.now

    category_links.each do |link|
      if !link.last_processed_at || (link.last_processed_at > current_datetime - CategoryLink::MINIMAL_TIME_OFFSET && !link.being_processed?)
        response = Faraday.get(link.url)

        if response.status == NOT_FOUND_CODE
          link.errors.add(:base, "Category not found")
        end
      else
        link.errors.add(:base, "Link can't be processed again in less than 3 hours")
      end
    end

    category_links
  end

  private

  def instantiate_links
    @category_links = urls.map do |url|
      CategoryLink.find_or_initialize_by_url(url)
    end
  end
end
