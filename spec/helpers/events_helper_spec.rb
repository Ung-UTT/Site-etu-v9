require 'spec_helper'

describe EventsHelper do
  describe "#mailto_link" do
    it "includes the name properly encoded" do
      event = build(:event, name: "World's On Fire!")
      helper.mailto_link(event).should =~ /World%27s%20On%20Fire%21/
    end
  end
end

