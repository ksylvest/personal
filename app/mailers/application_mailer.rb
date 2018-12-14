class ApplicationMailer < ActionMailer::Base
  default to: 'Kevin Sylvestre <info@ksylvest.com>'
  default from: 'info@ksylvest.com'

  layout 'mailer'
end
