require 'spec_helper'

RSpec.describe Project, type: :model do
  describe '.all' do
    it 'returns an array of projects' do
      expect(Project.all).to be_kind_of(Array)
    end
  end
end
