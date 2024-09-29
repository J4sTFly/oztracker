class NewCategoryLinksForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Conversion

  NOT_FOUND_CODE = 404

  attribute :urls, :string
  attribute :category_links, default: []

  validates :urls, presence: true

  def save
    return false if invalid?

    validate_links
    category_links.map { |link| link if link.errors.full_messages.blank? && link.save }.compact
  end

  def new_record?
    true
  end

  def persisted?
    !new_record?
  end

  private

  def validate_links
    instantiate_links
    current_datetime = DateTime.now

    category_links.each do |link|
      link.valid?
      if link.being_processed?
        link.errors.add(:base, "Category is already in progress")
      elsif !link.last_processed_at || (link.last_processed_at <= current_datetime - CategoryLink::MINIMAL_TIME_OFFSET)
        response = Faraday.get(link.url)

        link.errors.add(:base, "Category not found") if response.status == NOT_FOUND_CODE
      else
        link.errors.add(:base, "Category can't be processed again in less than 3 hours")
      end
    end
  end

  def instantiate_links
    self.category_links = urls.split("\r\n").uniq.map do |url|
      CategoryLink.find_or_initialize_by(url:)
    end
  end
end
