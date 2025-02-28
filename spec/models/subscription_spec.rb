require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject(:subscription) { build(:subscription) }

  it 'has a valid factory' do
    expect(subscription).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }
    it { should validate_presence_of(:stripe_id) }

    context 'when is canceled' do
      subject(:subscription) { build(:subscription, :canceled) }

      it { should validate_presence_of(:ends_at) }
    end
  end

  describe 'associations' do
    it { should belong_to(:plan) }
    it { should belong_to(:account) }
  end

  describe 'attributes' do
    it { should define_enum_for(:status).with_values(active: 0, canceled: 1) }
  end

  describe 'delegations' do
    it { should delegate_method(:name).to(:plan).with_prefix(true) }
  end

  describe '#on_grace_period?' do
    it 'returns false if the subscription is active' do
      subscription = create(:subscription, :active)

      expect(subscription.on_grace_period?).to eq(false)
    end

    it 'returns false if grace period has passed' do
      subscription = create(:subscription, :canceled, ends_at: 1.day.ago)

      expect(subscription.on_grace_period?).to eq(false)
    end

    it 'returns true if the subscription is canceled and grace period has not passed' do
      subscription = create(:subscription, :canceled, ends_at: 1.day.from_now)

      expect(subscription.on_grace_period?).to eq(true)
    end
  end
end
