require 'spec_helper'

describe Page do
  subject { Fabricate.build(:page) }

  it_behaves_like 'attachable'
  it_behaves_like 'searchable'
  it_behaves_like 'taggable'

  it { should belong_to(:user) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:summary) }
  it { should validate_presence_of(:body) }

  it { should validate_presence_of(:user) }

  it { should allow_value('ruby-on-rails').for(:slug) }
  it { should_not allow_value('Ruby on Rails').for(:slug) }

  it { should allow_value('2013-12-31').for(:slug) }
  it { should_not allow_value('2013 12 31').for(:slug) }

  describe '.search' do
    before(:each) do
      @match = Fabricate(:page, title: 'Ruby')
      @miss = Fabricate(:page, title: 'Python')
    end

    let(:results) { Page.search('Ruby') }

    it 'includes matches' do
      expect(results).to include(@match)
    end

    it 'excludes misses' do
      expect(results).to_not include(@miss)
    end
  end

end
