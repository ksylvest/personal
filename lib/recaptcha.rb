require 'recaptcha/api'
require 'recaptcha/config'

module Recaptcha
  def self.config
    @config ||= Recaptcha::Config.new
  end

  def self.verified?(**args)
    Recaptcha::API
      .new(config: config)
      .verify!(**args)
      .verified?
  end
end
