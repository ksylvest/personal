class Attachment < ApplicationRecord
  has_many :attachings, dependent: :destroy

  has_one_attached :file

  validates :name, presence: true
  validates :file, presence: true

  def icon
    case file.content_type
    when /audio\/.*/ then 'fas fa-file-audio'
    when /image\/.*/ then 'fas fa-file-image'
    when /video\/.*/ then 'fas fa-file-video'
    else 'fas fa-file'
    end
  end
end
