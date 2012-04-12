require 'spec_helper'

describe Role do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it {
      Role.create(:name => 'Role')
      should validate_uniqueness_of(:name).scoped_to(:asso_id)
    }
    it { should allow_value('Role name').for(:name) }
    it { should allow_value("Complex-based's role_user").for(:name) }
    it { should_not allow_value("Viva les {ROLES}").for(:name) }
  end
end
