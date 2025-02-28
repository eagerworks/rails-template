require 'rails_helper'

RSpec.describe Account, type: :model do
  subject(:account) { build(:account) }

  it 'has a valid factory' do
    expect(account).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:owner_id) }
  end

  describe 'associations' do
    it { should belong_to(:owner).class_name('User') }
    it { should have_many(:account_users).dependent(:destroy) }
    it { should have_many(:users).through(:account_users) }
    it { should have_many(:account_invitations).dependent(:destroy) }
    it { should have_one(:subscription).dependent(:destroy) }
    it { should have_one(:plan).through(:subscription) }
  end

  describe 'attachments' do
    it { should have_one_attached(:avatar) }
  end

  describe '#subscribed?' do
    context 'when no name is provided' do
      it 'returns true if the account has a subscription' do
        account = create(:account, :with_subscription)

        expect(account.subscribed?).to eq(true)
      end

      it 'returns false if the account does not have a subscription' do
        account = create(:account)

        expect(account.subscribed?).to eq(false)
      end
    end

    context 'when a name is provided' do
      it 'returns true if the account has a subscription with the provided name' do
        account = create(:account, :with_subscription)

        expect(account.subscribed?(name: account.plan.name)).to eq(true)
      end

      it 'returns false if the account does not have a subscription with the provided name' do
        account = create(:account, :with_subscription)

        expect(account.subscribed?(name: 'other')).to eq(false)
      end
    end
  end
end
