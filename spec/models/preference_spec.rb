require 'spec_helper'

describe Preference do
  describe 'validations' do
    it { should allow_value('fr').for(:locale) }
    it { should allow_value('en').for(:locale) }
    it { should_not allow_value('anglais').for(:locale) }
    it { should allow_value('all').for(:quote_type) }
    it { should_not allow_value('viva la carioca').for(:quote_type) }
  end
end
