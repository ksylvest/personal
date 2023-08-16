class Attachment < ApplicationRecord
  has_many :attachings, dependent: :destroy

  has_one_attached :file

  validates :name, presence: true
  validates :file, presence: true
end
