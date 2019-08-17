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
    'width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no'
  end

  def page(page)
    " | Page #{page}" if page.present?
  end

  def ld
    {
      '@context': 'http://schema.org', '@type': 'WebSite', 'url': root_url,
      'potentialAction':
      {
        '@type': 'SearchAction',
        'target': search_url(search: { query: '{search_query}' }),
        'query-input': 'required name=search_query',
      },
    }
  end

  def github_url
    'https://github.com/ksylvest'
  end

  def twitter_url
    'https://twitter.com/ksylvest'
  end

  def facebook_url
    'https://facebook.com/ksylvest'
  end

  def dribbble_url
    'https://dribbble.com/ksylvest'
  end

  def linkedin_url
    'https://www.linkedin.com/in/ksylvest'
  end

  def vimeo_url
    'https://vimeo.com/ksylvest'
  end

  def google_url
    'https://plus.google.com/+KevinSylvestre'
  end

  def stackoverflow_url
    'https://stackoverflow.com/users/259900/kevin-sylvestre?rel=author'
  end

  def attachment_tag(attachment, options = {})
    case attachment
    when Audio then audio_tag attachment.file.url, options
    when Image then image_tag attachment.file.url, options
    when Video then video_tag attachment.file.url, options
    end
  end
end
