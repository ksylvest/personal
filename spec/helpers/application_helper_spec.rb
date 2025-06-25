require "spec_helper"

RSpec.describe ApplicationHelper do
  describe "#markdown" do
    subject(:markdown) { helper.markdown(text) }

    context "with text" do
      let(:text) { "Example" }

      it "converts to markdown" do
        expect(markdown).to match("<p>Example</p>")
      end
    end

    context "with code" do
      let(:text) do
        <<~MARKDOWN
          ```language
          "hello"
          ```
        MARKDOWN
      end

      it "highlights code" do
        expect(markdown).to match('<pre class=\"highlight plaintext\"><code>')
        expect(markdown).to match("hello")
        expect(markdown).to match("</code></pre>")
      end
    end

    %w[original small large square].each do |variant|
      context "with a 'image' attachment using '#{variant}'" do
        let(:text) { "![Image](attachment:#{attachment.id}:#{variant})" }
        let(:attachment) { create(:attachment, :image) }

        it "generates an image" do
          expect(markdown).to match('<img alt="Image" src="http://test.host/rails/(.*)/image.png">')
        end
      end
    end
  end

  describe "#filters" do
    it "returns nothing unless a page is specified" do
      expect(helper.filters(page: nil, tag: nil)).to be_blank
    end

    it "returns something if a page is specified" do
      expect(helper.filters(page: 2, tag: "Ruby")).to be_present
    end
  end

  %w[github twitter facebook dribbble linkedin vimeo stackoverflow].each do |service|
    describe "##{service}_url" do
      it "returns a valid URL" do
        expect(helper.send("#{service}_url")).to match(Validation::URL)
      end
    end
  end

end
