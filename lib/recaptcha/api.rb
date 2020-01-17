module Recaptcha
  class API
    TIMEOUT = 3 # seconds
    URL = 'https://www.google.com/recaptcha/api/siteverify'.freeze

    private_constant :TIMEOUT
    private_constant :URL

    class RequestError < StandardError; end

    Response = Struct.new(:success, :score, :action, :hostname) do
      def verified?
        success
      end
    end

    def initialize(config:)
      @config = config
    end

    def verify!(response:, remoteip:)
      form = {
        response: response,
        remoteip: remoteip,
        secret: @config.secret_key,
      }
      response = http.accept(:json).post(URL, form: form)
      raise RequestError, response unless response.status.ok?

      data = JSON.parse(response.body)
      Response.new(data['success'], data['score'], data['action'], data['hostname'])
    end

  private

    def http
      HTTP.timeout(TIMEOUT)
    end
  end
end
