require 'rails_helper'

RSpec.describe AccountInvitation, type: :model do
  subject(:account_invitation) { build(:account_invitation) }

  it 'has a valid factory' do
    expect(account_invitation).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
    it {
      should validate_uniqueness_of(:email).scoped_to(:account_id)
                                           .with_message('has already been invited')
                                           .case_insensitive
    }
  end

  describe 'associations' do
    it { should belong_to(:account) }
    it { should belong_to(:invited_by).class_name('User') }
  end

  describe 'attributes' do
    it { should define_enum_for(:role).with_values(member: 0, admin: 1) }
    it { should have_secure_token }
  end

  describe '#to_param' do
    it 'returns the token' do
      expect(account_invitation.to_param).to eq(account_invitation.token)
    end
  end
end
