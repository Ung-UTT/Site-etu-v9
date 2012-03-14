require 'spec_helper'

describe Role do
  fixtures :users

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it {
      Role.create(:name => 'Role')
      should validate_uniqueness_of(:name).scoped_to(:asso_id)
    }
    it { should allow_value('Role name').for(:name) }
    it { should allow_value("Complex-based's role_user").for(:name) }
    #FIXME: it { should_not allow_value("Viv@ lês {RÔLES}").for(:name) }
  end

  describe 'Associations' do
    it { should belong_to(:asso) }

    it { should have_many(:users).through(:roles_user) }
  end
end
