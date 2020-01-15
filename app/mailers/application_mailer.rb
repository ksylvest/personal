class ApplicationMailer < ActionMailer::Base
  default to: 'Kevin Sylvestre <info@ksylvest.com>'
  default from: "notifications@#{Rails.application.credentials.fetch(:mailgun, domain: 'ksylvest.com')[:domain]}"

  layout 'mailer'
end
