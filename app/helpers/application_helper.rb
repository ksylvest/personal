module ApplicationHelper
  def active?(*mode)
    mode.include?(params[:controller]) || mode.include?(params[:action])
  end

  def srcset(path, format:, sizes: %w[1x 2x 3x])
    sizes.map { |size| "#{image_path("#{path}-#{size}.#{format}")} #{size}" }.join(',')
  end

  def markdown(text)
    render = Redcarpet::Render::Advanced.new
    render.helper = self
    markdown = Redcarpet::Markdown.new(render, fenced_code_blocks: true)
    sanitize markdown.render(text)
  end

  def viewport
    'width=device-width,initial-scale=1.0'
  end

  def page(page)
    " | Page #{page}" if page.present?
  end

  def ld
    {
      '@context': 'http://schema.org',
      '@type': 'WebSite',
      'url': root_url,
      'potentialAction': {
        '@type': 'SearchAction',
        'target': "#{search_url}?query={query}",
        'query-input': 'required name=query',
      },
    }
  end

  def release
    "#{ENV.fetch('HEROKU_APP_NAME', 'playground')}@#{ENV.fetch('HEROKU_RELEASE_VERSION', 'local')}"
  end
end
