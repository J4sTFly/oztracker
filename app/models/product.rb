class Product < ApplicationRecord
  has_many :prices

  validates :link, :name, :image_link, presence: true

  def full_name
    "#{name} - #{author}"
  end
end
