require 'spec_helper'

describe Validation do

  it 'validates URLs' do
    expect('https://ksylvest.com').to match(Validation::URL)
    expect('ksylvest.com').to_not match(Validation::URL)
  end

  it 'validates emails' do
    expect('kevin@ksylvest.com').to match(Validation::EMAIL)
    expect('kevin').to_not match(Validation::EMAIL)
  end

  it 'validates permalinks' do
    expect('2014-12-31-something').to match(Validation::PERMALINK)
    expect('2014 12 31 something').to_not match(Validation::PERMALINK)
  end

end
