module ApplicationHelper
  def active?(*mode)
    mode.include?(params[:controller]) || mode.include?(params[:action])
  end

  def prose(&)
    tag.div(class: [
      "prose",
      "prose-slate",
      "prose-a:text-indigo-600",
      "prose-pre:bg-slate-50",
      "prose-pre:text-slate-800",
      "prose-pre:text-base",
      "prose-pre:p-4",
      "max-w-none",
      "min-w-none",
    ].join(" "), &)
  end

  def markdown(text)
    render = Redcarpet::Render::Advanced.new
    render.helper = self
    markdown = Redcarpet::Markdown.new(render, fenced_code_blocks: true)
    sanitize markdown.render(text)
  end

  def viewport
    "width=device-width,initial-scale=1.0"
  end

  def filters(page:, tag:)
    [
      (" | ##{tag}" if tag.present?),
      (" | Page #{page}" if page.present?),
    ].compact.join
  end

  def ld
    {
      "@context": "http://schema.org",
      "@type": "WebSite",
      "url": root_url,
      "potentialAction": {
        "@type": "SearchAction",
        "target": "#{search_url}?query={query}",
        "query-input": "required name=query",
      },
    }
  end

  # @return [Array<Array(String, String)>]
  def header_nav
    [
      ["Home", root_path],
      ["About", about_path],
      ["Contact", contact_path],
      ["Projects", projects_path],
      ["Portfolio", portfolio_path],
      ["Search", search_path],
    ]
  end

  # @return [Array<Array(String, String)>]
  def footer_nav
    [
      ["GitHub", github_url],
      ["Twitter", twitter_url],
      ["Facebook", facebook_url],
      ["Linkedin", linkedin_url],
      ["Dribbble", dribbble_url],
      ["Stack", stackoverflow_url],
      ["Vimeo", vimeo_url],
      ["Status", status_url],
      ["Feed", feed_url(:atom)],
    ]
  end

  def release
    "#{ENV.fetch('HEROKU_APP_NAME', 'playground')}@#{ENV.fetch('HEROKU_RELEASE_VERSION', 'local')}"
  end
end
