require 'rspec'
require './grid_loader'
require './grid'

describe Griddlers::GridLoader do
  subject { Griddlers::GridLoader }

  it 'should be a valid file' do
    expect(subject.valid_file?('./games/small')).to eq true
    expect(subject.valid_file?('./games/medium')).to eq true
  end

  it 'should not be a valid file' do
    expect(subject.valid_file?('./games/invalid')).to eq false
  end

  it 'should return an object of type Grid' do
    expect(subject.load('./games/small').class).to eq Griddlers::Grid
  end
end
