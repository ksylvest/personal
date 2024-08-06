require 'rouge'
require 'rouge/plugins/redcarpet'

class Redcarpet::Render::Advanced < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet

  attr_accessor :helper

  def image(link, title, alt)
    helper.image_tag(internalize(link), title:, alt:)
  end

protected

  def internalize(link)
    attributes = link.match(/^attachment:(?<id>\d+):(?<variant>\w+)$/)
    file = Attachment.find(attributes[:id]).file

    case attributes[:variant]
    when 'original' then file
    when 'small' then file.variant(resize: '480x480')
    when 'large' then file.variant(resize: '960x960')
    when 'square' then file.variant(thumbnail: '120x120')
    end
  end

end
