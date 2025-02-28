require 'rails_helper'

RSpec.describe AccountUser, type: :model do
  subject(:account_user) { build(:account_user) }

  it 'has a valid factory' do
    expect(account_user).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:user) }
  end

  describe 'delegations' do
    it { should delegate_method(:avatar).to(:user) }
    it { should delegate_method(:full_name).to(:user) }
    it { should delegate_method(:email).to(:user) }
  end

  describe 'attributes' do
    it { should define_enum_for(:role).with_values(member: 0, admin: 1) }
  end

  describe '#owner?' do
    it 'returns true if the account user is the owner of the account' do
      account_user = create(:account_user, role: :admin)
      account_user.account.update(owner: account_user.user)

      expect(account_user.owner?).to eq(true)
    end

    it 'returns false if the account user is not the owner of the account' do
      account_user = create(:account_user, role: :admin)

      expect(account_user.owner?).to eq(false)
    end
  end
end
