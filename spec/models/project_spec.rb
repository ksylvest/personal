require 'spec_helper'

describe Project do
  describe '.all' do
    it 'returns an array of projects' do
      expect(Project.all).to be_kind_of(Array)
    end
  end
end
