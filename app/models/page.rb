class Page
  include Comparable

  class ParseError < StandardError; end

  ROOT = Rails.root.join(Rails.env.test? ? "spec/fixtures" : "config/content", "pages")

  FILE_REGEX = /\A
    \s*---\s*
    (?<metadata>.*?)
    \s*---\s*
    (?<content>.*)
  \Z/mx

  attr_reader :slug
  attr_reader :date
  attr_reader :title
  attr_reader :summary
  attr_reader :tags
  attr_reader :canonical_url
  attr_reader :content

  alias body content

  # @param slug [String]
  # @return [Page, nil]
  def self.find(slug:)
    parse!(path: ROOT.join("#{slug}.md"))
  end

  # @param slug [String]
  # @raise [ActionController::RoutingError] when not found
  # @return [Page]
  def self.find!(slug:)
    find(slug:) || raise(ActionController::RoutingError, "Page not found: #{slug}")
  end

  # @return [Array<Page>]
  def self.all
    ROOT.glob("*.md")
      .map { |path| parse!(path:) }
      .sort
  end

  # @param tag [String, nil]
  # @return [Array<Page>]
  def self.tagged(tag:)
    return all if tag.blank?

    all.filter { |page| page.tagged?(tag:) }
  end

  # Matches when every term in the query appears in the title, summary, or body (ignoring case).
  #
  # @param query [String, nil]
  # @return [Array<Page>]
  def self.search(query:)
    terms = String(query).downcase.split(/\W+/).compact_blank
    return [] if terms.empty?

    all.filter { |page| page.matches?(terms:) }
  end

  # Parses a page structured as:
  #
  #   ---
  #   date: "2024-01-01"
  #   title: Uses
  #   summary: The hardware and software I use.
  #   tags:
  #     - setup
  #   canonical_url: https://example.com/original (optional)
  #   ---
  #   A list of things...
  #
  # @param path [Pathname]
  # @return [Page, nil]
  def self.parse!(path:) # rubocop:disable Metrics/AbcSize
    return unless File.exist?(path)

    slug = String(path.basename(".md")).parameterize

    matches = FILE_REGEX.match(File.read(path, encoding: "UTF-8"))
    raise ParseError, "Invalid page: #{slug}" unless matches

    metadata = YAML.safe_load(matches[:metadata], permitted_classes: [Date])

    new(
      slug:,
      date: Date.parse(String(metadata.fetch("date"))),
      title: metadata.fetch("title").strip,
      summary: metadata.fetch("summary").strip,
      tags: Array(metadata["tags"]).map(&:to_s).sort,
      canonical_url: metadata["canonical_url"].presence,
      content: matches[:content].strip
    )
  end

  # @param slug [String] e.g. 'uses'
  # @param date [Date] e.g. 2024-01-01
  # @param title [String] e.g. 'Uses'
  # @param summary [String] e.g. 'The hardware and software I use.'
  # @param tags [Array<String>] e.g. ['setup']
  # @param canonical_url [String, nil] e.g. 'https://example.com/original'
  # @param content [String] markdown
  def initialize(slug:, date:, title:, summary:, tags:, content:, canonical_url: nil) # rubocop:disable Metrics/ParameterLists
    @slug = slug
    @date = date
    @title = title
    @summary = summary
    @tags = tags
    @canonical_url = canonical_url
    @content = content
  end

  # Newest first (ties broken by slug for a stable order).
  #
  # @return [Integer]
  def <=>(other)
    [other.date, slug] <=> [date, other.slug]
  end

  # @param tag [String]
  # @return [Boolean]
  def tagged?(tag:)
    @tags.include?(tag)
  end

  # @param terms [Array<String>] lowercase
  # @return [Boolean]
  def matches?(terms:)
    text = [title, summary, content].join(" ").downcase
    terms.all? { |term| text.include?(term) }
  end

  # @return [String]
  def keywords
    tags.join(",")
  end
end
