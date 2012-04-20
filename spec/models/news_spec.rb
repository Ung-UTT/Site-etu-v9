require 'spec_helper'

describe News do
  it { should validate_presence_of(:title) }
end

