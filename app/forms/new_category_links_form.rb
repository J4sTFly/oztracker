class NewCategoryLinksForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Conversion

  attribute :urls, :string
  attribute :requestable_links

  validates :urls, presence: true

  def save
    return false if invalid?

    # Return only invalid links
    validate_links
    requestable_links.map { |link| link if link.valid? && link.new_record? && link.save }
  end

  def attributes
    super.symbolize_keys
  end

  def new_record?
    true
  end

  def persisted?
    !new_record?
  end

  private

  def validate_links
    @requestable_links = ValidateLinksService.new(urls).call
  end
end
