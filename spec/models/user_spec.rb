require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'associations' do
    it { should have_many(:account_users).dependent(:destroy) }
    it { should have_many(:accounts).through(:account_users) }
    it { should have_many(:owned_accounts).class_name('Account').dependent(:destroy) }
    it { should have_many(:credentials).dependent(:destroy) }
  end

  describe 'attachments' do
    it { should have_one_attached(:avatar) }
  end

  describe '#create_default_account' do
    subject(:user) { create(:user) }

    it 'creates a new account' do
      expect { user.create_default_account }.to change { user.accounts.count }.by(1)
    end

    it 'creates a new account with the user as the owner' do
      account = user.create_default_account
      expect(account.owner).to eq(user)
    end

    it 'creates a new account with the user as an admin' do
      account = user.create_default_account
      expect(account.account_users.find_by(user: user).role).to eq('admin')
    end

    it 'creates a new account with the user\'s full name' do
      account = user.create_default_account
      expect(account.name).to eq(user.full_name)
    end

    it 'creates a new account with the personal flag set to true' do
      account = user.create_default_account
      expect(account.personal).to eq(true)
    end
  end

  describe '#multi_account?' do
    it 'returns true if the user has more than one account' do
      user = create(:user)
      create(:account_user, user: user)
      create(:account_user, user: user)
      expect(user.multi_account?).to eq(true)
    end

    it 'returns false if the user has only one account' do
      user = create(:user)
      create(:account_user, user: user)
      expect(user.multi_account?).to eq(false)
    end
  end

  describe '#two_factor_enabled?' do
    it 'returns true if the user has credentials' do
      user = create(:user)
      create(:credential, user: user)
      expect(user.two_factor_enabled?).to eq(true)
    end
  end

  describe '.from_omniauth' do
    context 'when the user does not exist' do
      it 'creates a new user' do
        auth = OmniAuth::AuthHash.new(provider: 'google_oauth2', uid: '123',
                                      info: { email: 'new@user.com', name: 'New User' })
        expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
      end
    end

    context 'when the user exists' do
      subject!(:user) { create(:user, provider: 'google_oauth2', uid: '123') }

      it 'returns the existing user' do
        auth = OmniAuth::AuthHash.new(provider: 'google_oauth2', uid: '123')
        expect(User.from_omniauth(auth)).to eq(user)
      end
    end

    context 'when the user exists with the same email' do
      subject(:user) { create(:user) }

      it 'updates the provider and uid' do
        auth = OmniAuth::AuthHash.new(provider: 'google_oauth2', uid: '123',
                                      info: { email: user.email })
        User.from_omniauth(auth)
        user.reload
        expect(user.provider).to eq('google_oauth2')
        expect(user.uid).to eq('123')
      end
    end
  end
end
