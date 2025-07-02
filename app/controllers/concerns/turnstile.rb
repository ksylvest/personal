module Turnstile
  extend ActiveSupport::Concern

  # @return [Boolean]
  def turnstile?
    Rails.env.local? || fetch_turnstile_siteverify["success"]
  end

  # @return [Hash]
  def fetch_turnstile_siteverify
    payload = {
      remoteip: request.remote_ip,
      response: params["cf-turnstile-response"],
      secret: Rails.application.credentials.turnstile.secret_key!,
    }
    response = HTTP.post("https://challenges.cloudflare.com/turnstile/v0/siteverify", json: payload)
    response.parse
  end
end
