require 'rspec'
require './cell'

describe Griddlers::Cell do
  subject { Griddlers::Cell.new(filled) }
  let(:filled) { true }

  it 'should be of type Cell' do
    expect(subject.class).to eq Griddlers::Cell
  end

  it 'should be filled by definition' do
    expect(subject.should_be_filled?).to eq true
  end

  it 'should be empty yet' do
    expect(subject.filled?).to eq false
    expect(subject.empty?).to eq true
  end

  it 'should be filled after coloring' do
    subject.colour!(1)
    expect(subject.filled?).to eq true
    expect(subject.empty?).to eq false
  end

  it 'should be filled after another coloring' do
    subject.colour!(1)
    expect(subject.filled?).to eq true
    expect(subject.empty?).to eq false
  end

  it 'should be empty after erasing' do
    subject.erase!
    expect(subject.filled?).to eq false
    expect(subject.empty?).to eq true
  end

  it 'should be empty after another erasing' do
    subject.erase!
    expect(subject.filled?).to eq false
    expect(subject.empty?).to eq true
  end

  it 'should be able to printable' do
    subject.erase!
    expect(subject.to_s).to eq ' '
    subject.colour!(0)
    expect(subject.to_s).to eq ' '
    subject.colour!(1)
    expect(subject.to_s).to eq 'x'
  end
end
