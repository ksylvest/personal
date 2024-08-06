class Portfolio
  attr_reader :name
  attr_reader :summary

  def self.all
    @all ||= YAML.load_file(Rails.root.join('config/portfolio.yml')).map { |config| new(config) }
  end

  def initialize(config)
    @slug = config['slug']
    @name = config['name']
    @summary = config['summary']
    @images = config['images']
    @videos = config['videos']
  end

  def images
    return unless @images

    size = @images['size']
    files = @images['files']
    files.each do |file|
      yield({
        size:,
        original: "portfolio/originals/#{@slug}/#{file}",
        thumb: "portfolio/thumbs/#{@slug}/#{file}",
      })
    end
  end

  def videos
    return unless @videos

    urls = @videos['urls']
    urls.each do |url|
      yield({ url: })
    end
  end
end
