require 'spec_helper'

describe ApplicationHelper do
  describe '#markdown' do
    it 'converts to markdown' do
      expect(helper.markdown('Example')).to match('<p>Example</p>')
    end
    it 'highlights code' do
      markdown = helper.markdown <<~SAMPLE
        ```language
        "hello"
        ```
      SAMPLE

      expect(markdown).to match('<pre class=\"highlight plaintext\"><code>')
      expect(markdown).to match('hello')
      expect(markdown).to match('</code></pre>')
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
