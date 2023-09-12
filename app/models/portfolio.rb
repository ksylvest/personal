class Portfolio < ApplicationRecord
  validates :name, presence: true
  validates :summary, presence: true
  has_many_attached :images
end
