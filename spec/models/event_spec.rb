require 'spec_helper'

describe Event do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
