require "spec_helper"

RSpec.describe Page do
  subject { build(:page) }

  it_behaves_like "approvable"
  it_behaves_like "attachable"
  it_behaves_like "searchable"
  it_behaves_like "taggable"

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:summary) }
  it { is_expected.to validate_presence_of(:body) }

  it { is_expected.to allow_value("ruby-on-rails").for(:slug) }
  it { is_expected.not_to allow_value("Ruby on Rails").for(:slug) }

  it { is_expected.to allow_value("2013-12-31").for(:slug) }
  it { is_expected.not_to allow_value("2013 12 31").for(:slug) }

  describe ".search" do
    subject(:search) { Page.search("Potato") }

    let!(:match) { create(:page, title: "Potato") }
    let!(:miss) { create(:page, title: "Tomato") }

    it 'includes a page about "Potato" when searching for "Potato"' do
      expect(search).to include(match)
    end

    it 'excludes a page about "Tomato" when searching for "Potato"' do
      expect(search).not_to include(miss)
    end
  end

end
