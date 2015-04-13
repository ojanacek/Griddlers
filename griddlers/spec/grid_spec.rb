require 'rspec'
require './grid_loader'
require './grid'

describe Griddlers::Grid do
  subject { Griddlers::GridLoader.load(file) }
  let(:file) { './games/small' }

  it 'should provide information about size' do
    expect(subject.columns).to eq 15
    expect(subject.rows).to eq 15
  end

  it 'should have a cell empty and filed by definition' do
    expect(subject[0, 0].should_be_filled?).to eq false
    expect(subject[0, 2].should_be_filled?).to eq true
    expect(subject[14, 13].should_be_filled?).to eq true
    expect(subject[14, 14].should_be_filled?).to eq false
  end

  it 'should should be empty' do
    expect(subject.all_filled?).to eq false
  end

  it 'should colour a cell' do
    subject.erase!(0, 0)
    subject.colour!(0, 0, 1)
    expect(subject[0, 0].filled?).to eq true
  end

  it 'should erase a cell' do
    subject.colour!(0, 0, 1)
    subject.erase!(0, 0)
    expect(subject[0, 0].empty?).to eq true
  end

  it 'should be valid' do
    expect(subject.valid?).to eq true
    subject.colour!(0, 2, 1)
    expect(subject.valid?).to eq true
  end

  it 'should not be valid' do
    subject.colour!(0, 0, 1)
    expect(subject.valid?).to eq false
  end

  it 'should return a correct colour' do
    subject.erase!(0, 0)
    expect(subject.send(:cell_colour, 0, 0)).to eq subject.colour_empty
    subject.colour!(0, 0, 0)
    expect(subject.send(:cell_colour, 0, 0)).to eq subject.colour_space
    subject.colour!(0, 0, 1)
    expect(subject.send(:cell_colour, 0, 0)).to eq subject.colour_filled
  end
end
