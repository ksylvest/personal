require 'spec_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#markdown' do
    context 'with text' do
      subject(:markdown) do
        helper.markdown(<<~MARKDOWN)
          Example
        MARKDOWN
      end

      it 'converts to markdown' do
        expect(markdown).to match('<p>Example</p>')
      end
    end

    context 'with code' do
      subject(:markdown) do
        helper.markdown(<<~MARKDOWN)
          ```language
          "hello"
          ```
        MARKDOWN
      end

      it 'highlights code' do
        expect(markdown).to match('<pre class=\"highlight plaintext\"><code>')
        expect(markdown).to match('hello')
        expect(markdown).to match('</code></pre>')
      end
    end
  end

  describe '#page' do
    it 'returns nothing unless a page is specified' do
      expect(helper.page('')).to be_blank
    end

    it 'returns something if a page is specified' do
      expect(helper.page('Amazing')).to be_present
    end
  end

  %w[github twitter facebook dribbble linkedin vimeo google stackoverflow].each do |service|
    describe "##{service}_url" do
      it 'returns a valid URL' do
        expect(helper.send("#{service}_url")).to match(Validation::URL)
      end
    end
  end

end
