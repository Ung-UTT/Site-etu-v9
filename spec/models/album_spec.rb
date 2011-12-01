require 'spec_helper'

describe Album do
  before(:all) do
    @e1 = Event.create(:name => 'Event 1')
    @e2 = Event.create(:name => 'Event 2')
    @image = Document.create(:documentable => @e1, :asset => File.new(Rails.root + 'spec/assets/image.png'))
  end

  it 'should return all events with images' do
    Album.all.include?(Album.find(@e1)).should be_true
  end

  it 'should find an album by event id' do
    Album.find(@e1)[:event].should == @e1
  end

  it 'should correctly convert event to album' do
    Album.find(@e1)[:images].first.should == @image
  end
end
