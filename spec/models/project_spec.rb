require 'spec_helper'

RSpec.describe Project, type: :model do
  describe '.all' do
    it 'returns an array of projects' do
      expect(Project.all).to be_a(Array)
    end
  end
end
