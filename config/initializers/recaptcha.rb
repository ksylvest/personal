require 'recaptcha'

if Rails.application.credentials.recaptcha
  Recaptcha.config.site_key = Rails.application.credentials.recaptcha[:site_key]
  Recaptcha.config.secret_key = Rails.application.credentials.recaptcha[:secret_key]
end
