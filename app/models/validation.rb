module Validation
  URL = /\Ahttp[s]?:\/\/.+\Z/i.freeze
  EMAIL = /\A([\S]+)@([\S]+)\.([\S]+)\Z/i.freeze
  PERMALINK = /\A\S+\Z/.freeze
end
