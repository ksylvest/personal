module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search, ->(query, fields = %w[title summary body]) {
      query.present? ? where(Tokenizer.instance.generate(query, fields, connection.method(:quote))) : none
    }
  end

  class Tokenizer
    include Singleton

    LANGUAGE = "english".freeze
    SEPARATOR = /\W+/

    def generate(query, fields, sanitizer)
      "(#{searchables(fields)}) @@ (#{tokens(query, sanitizer)})"
    end

  private

    def searchables(fields, conjunction = " || ' ' || ")
      tsvector(fields.map { |field| "coalesce(#{field}, '')" }.join(conjunction))
    end

    def tokens(query, sanitizer, conjunction = " && ")
      query.split(SEPARATOR).map { |term| tsquery(term, sanitizer) }.join(conjunction)
    end

    def tsquery(string, sanitizer)
      "to_tsquery('#{LANGUAGE}', #{sanitizer.call string})"
    end

    def tsvector(string)
      "to_tsvector('#{LANGUAGE}', #{string})"
    end

  end

end
