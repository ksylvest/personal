require "spec_helper"

RSpec.describe Post do
  subject { build(:post) }

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

  describe ".search" do
    subject(:search) { Post.search("Ruby") }

    let!(:match) { create(:post, title: "Ruby") }
    let!(:miss) { create(:post, title: "Python") }

    it 'includes a post about "Ruby" when searching for "Ruby"' do
      expect(search).to include(match)
    end

    it 'excludes a post about "Python" when searching for "Ruby"' do
      expect(search).not_to include(miss)
    end
  end
end
