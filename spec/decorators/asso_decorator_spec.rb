require 'spec_helper'

describe AssoDecorator do
  describe "#to_s" do
    it "includes the name" do
      asso = build :asso
      AssoDecorator.new(asso).to_s.should include asso.name
    end
  end
end
