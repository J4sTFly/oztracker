class CategoryLink < ApplicationRecord
  validates :url, presence: true

  # Minimal time offset to process link again
  MINIMAL_TIME_OFFSET = 3.hours
end
