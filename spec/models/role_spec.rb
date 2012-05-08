require 'spec_helper'

describe Role do
  it 'describe itself correctly' do
    role = build :role
    role.to_s.should include role.name
  end
end
