class CategoryLink < ApplicationRecord
  # Minimal time offset to process link again
  MINIMAL_TIME_OFFSET = 3.hours
  PROTOCOL = "https"
  OZ_HOSTNAME = "oz.by"

  validates :url, presence: true
  validate :oz?, :https?, if: -> { url.present? && URI.parse(url).absolute? }

  def uri
    @uri ||= URI(url)
  end

  private

  def https?
    errors.add(:base, "Link Protocol invalid") unless uri.scheme == PROTOCOL
  end

  def oz?
    errors.add(:base, "Not a link to OZ.by") unless uri.host == OZ_HOSTNAME
  end
end
