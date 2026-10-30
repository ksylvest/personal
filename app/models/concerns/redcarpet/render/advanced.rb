require "rouge"
require "rouge/plugins/redcarpet"

class Redcarpet::Render::Advanced < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end
