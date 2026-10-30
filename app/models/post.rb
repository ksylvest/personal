class Post
  include Comparable

  class ParseError < StandardError; end

  ROOT = Rails.root.join(Rails.env.test? ? "spec/fixtures" : "config/content", "posts")

  FILE_REGEX = /\A
    \s*---\s*
    (?<metadata>.*?)
    \s*---\s*
    (?<content>.*)
  \Z/mx

  SEGMENT_FORMAT = "%Y-%m-%d".freeze

  attr_reader :slug
  attr_reader :date
  attr_reader :title
  attr_reader :summary
  attr_reader :tags
  attr_reader :canonical_url
  attr_reader :content

  alias body content

  # @param slug [String]
  # @return [Post, nil]
  def self.find(slug:)
    all.find { |post| post.slug.eql?(slug) }
  end

  # @param slug [String]
  # @raise [ActionController::RoutingError] when not found
  # @return [Post]
  def self.find!(slug:)
    find(slug:) || raise(ActionController::RoutingError, "Post not found: #{slug}")
  end

  # @return [Array<Post>]
  def self.all
    @all ||= ROOT.glob("*.md")
      .map { |path| parse!(path:) }
      .sort
  end

  # @param tag [String, nil]
  # @return [Array<Post>]
  def self.tagged(tag:)
    return all if tag.blank?

    all.filter { |post| post.tagged?(tag:) }
  end

  # Matches when every term in the query appears in the title, summary, or body (ignoring case).
  #
  # @param query [String, nil]
  # @return [Array<Post>]
  def self.search(query:)
    terms = String(query).downcase.split(/\W+/).compact_blank
    return [] if terms.empty?

    all.filter { |post| post.matches?(terms:) }
  end

  # Parses a post structured as:
  #
  #   ---
  #   date: "2014-05-28"
  #   title: Rails Concerns for URL and Path Helpers
  #   summary: Concerns offer a reusable way of sharing common code.
  #   tags:
  #     - ruby
  #     - rails
  #   canonical_url: https://example.com/original (optional)
  #   ---
  #   Accessing a URL or path directly from a model can help...
  #
  # @param path [Pathname]
  # @return [Post, nil]
  def self.parse!(path:) # rubocop:disable Metrics/AbcSize
    return unless File.exist?(path)

    slug = String(path.basename(".md")).parameterize

    matches = FILE_REGEX.match(File.read(path, encoding: "UTF-8"))
    raise ParseError, "Invalid post: #{slug}" unless matches

    metadata = YAML.safe_load(matches[:metadata], permitted_classes: [Date])

    new(
      slug:,
      date: Date.parse(String(metadata.fetch("date"))),
      title: metadata.fetch("title").strip,
      summary: metadata.fetch("summary").strip,
      tags: metadata.fetch("tags", []).sort,
      canonical_url: metadata["canonical_url"].presence,
      content: matches[:content].strip
    )
  end

  # @param slug [String] e.g. 'rails-concerns-for-url-and-path-helpers'
  # @param date [Date] e.g. 2014-05-28
  # @param title [String] e.g. 'Rails Concerns for URL and Path Helpers'
  # @param summary [String] e.g. 'Concerns offer a reusable way of sharing common code.'
  # @param tags [Array<String>] e.g. ['ruby', 'rails']
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

  # @return [String] e.g. '2014-05-28' (used in /posts/:segment/:slug)
  def segment
    date.strftime(SEGMENT_FORMAT)
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
