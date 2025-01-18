require "spec_helper"

RSpec.describe "compression", type: :request do
  describe "a request with gzip or deflate" do
    %w[gzip deflate,gzip gzip,deflate].each do |http_accept_encoding|
      it "sets a content encoding for '#{http_accept_encoding}'" do
        get root_path, headers: { "HTTP_ACCEPT_ENCODING" => http_accept_encoding }
        expect(response.headers["Content-Encoding"]).to be_present
      end
    end
  end

  describe "a request without gzip or deflate" do
    it "does not set a content encoding for no accept content encoding" do
      get root_path
      expect(response.headers["Content-Encoding"]).to be_blank
    end
  end
end
