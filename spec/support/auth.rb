module Auth
  module Helpers
    def authenticate(user)
      post(auth_path, params: { token: user.to_signed_global_id(for: "auth") })
    end

    def deauthenticate
      delete(auth_path)
    end
  end
end

RSpec.configure do |config|
  config.include(Auth::Helpers, type: :request)
end
