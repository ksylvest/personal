class Page < ApplicationRecord
  include Taggable
  include Approvable
  include Searchable
  include Attachable

  belongs_to :user

  validates :title, presence: true
  validates :summary, presence: true
  validates :body, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: Validation::PERMALINK }

  before_validation :defaults!

  scope :ordered, -> { order('id DESC') }
  scope :optimized, -> { includes(:user) }

  scope :canonical, -> { where(canonical_url: nil) }

  def date
    created_at || updated_at
  end

private

  def defaults!
    self.slug ||= title.parameterize if title.present?
  end

end
