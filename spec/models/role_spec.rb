require 'spec_helper'

describe Role do
  it 'describe itself correctly' do
    role = build :role
    role.to_s.include?(role.name).should be_true
  end
end
