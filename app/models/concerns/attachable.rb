module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachings, as: :document, dependent: :destroy
    has_many :attachments, through: :attachings

    before_save :attach!
  end

  def attach!(attributes: %w[title summary body])
    return unless (changed & attributes).any?

    self.attachments = Attachment.find(Attacher.instance.ids(self, attributes))
  end

  class Attacher
    include Singleton

    REGEX = /attachment:(?<id>\d+):(?<style>\w+)/.freeze

    def ids(object, attributes)
      strings(object, attributes).map { |string| parse(string) }.flatten
    end

  private

    def strings(object, attributes)
      attributes.map { |attribute| object[attribute] }.compact
    end

    def parse(string)
      Array(string.scan(REGEX).collect { |id, _| id })
    end
  end
end
