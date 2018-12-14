class Portfolio

  attr_reader :name, :slug, :url

  def initialize(slug, name, url)
    @slug = slug
    @name = name
    @url = url
  end

  def self.all
    [
      POSE,
      SURKUS,
      HEARTS,
      VIDFOLIA,
      WINESCAN,
    ]
  end

  def images
    case slug
    when :pose then %w[01 02 03 04 05 06 07 08 09 10 11 12]
    when :hearts then %w[01 02 03 04 05 06]
    when :vidfolia then %w[01 02 03]
    when :winescan then %w[01 02 03 04 05 06 07 08 09 10 11 12]
    when :surkus then %w[01 02 03 04 05 06]
    end
  end

  POSE = new(:pose, 'Pose', 'https://pose.com')
  HEARTS = new(:hearts, 'Hearts', 'https://gethearts.com')
  VIDFOLIA = new(:vidfolia, 'Vidfolia', 'https://vidfolia.com')
  WINESCAN = new(:winescan, 'Winescan', 'http://api.winescan.ca')
  SURKUS = new(:surkus, 'Surkus', 'https://surkus.com')

end
