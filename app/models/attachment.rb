class Attachment < ApplicationRecord
  has_many :attachings, dependent: :destroy

  has_one_attached :file

  validates :name, presence: true
  validates :file, presence: true

  def icon
    case file.content_type
    when /audio\/.*/ then 'fal fa-file-audio'
    when /image\/.*/ then 'fal fa-file-image'
    when /video\/.*/ then 'fal fa-file-video'
    else 'fal fa-file'
    end
  end
end
