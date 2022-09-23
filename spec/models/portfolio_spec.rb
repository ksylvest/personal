require 'spec_helper'

RSpec.describe Portfolio, type: :model do
  describe '.all' do
    it 'returns an array of projects' do
      expect(Portfolio.all).to be_a(Array)
    end
  end
end
