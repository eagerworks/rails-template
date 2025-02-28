require 'rails_helper'

RSpec.describe Plan, type: :model do
  subject(:plan) { build(:plan) }

  it 'has a valid factory' do
    expect(plan).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:interval) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:interval) }
    it { should validate_presence_of(:currency) }

    context 'when it is charged per unit' do
      subject(:plan) { build(:plan, charge_per_unit: true) }

      it { should validate_presence_of(:unit_label) }
    end
  end

  describe 'attributes' do
    it { should define_enum_for(:interval).with_values(monthly: 0, yearly: 1) }

    it 'normalizes currency to lowercase' do
      plan.currency = 'USD'
      plan.valid?
      expect(plan.currency).to eq('usd')
    end
  end

  describe 'feaures' do
    it 'returns features inside of details' do
      plan.details = { features: ['Feature 1', 'Feature 2'] }

      expect(plan.features).to eq(['Feature 1', 'Feature 2'])
    end

    it 'returns an empty array if details is nil' do
      plan.details = nil

      expect(plan.features).to eq([])
    end
  end

  describe 'associations' do
    it { should have_many(:subscriptions) }
  end

  describe '.published' do
    before do
      create_list(:plan, 5, private: true)
      create(:plan, 5, private: false)

      it 'returns only published plans' do
        expect(Plan.published.count).to eq(5)
        Plan.published.each do |plan|
          expect(plan.private).to eq(false)
        end
      end
    end
  end

  describe '#formatted_features' do
    it 'returns the features as a string' do
      plan.features = ['Feature 1', 'Feature 2', 'Feature 3']

      expect(plan.formatted_features).to eq("Feature 1\nFeature 2\nFeature 3")
    end
  end

  describe '#formatted_features=' do
    it 'sets the features from a string' do
      plan.formatted_features = "Feature 1\nFeature 2"

      expect(plan.features).to eq(['Feature 1', 'Feature 2'])
    end
  end

  describe '#trial?' do
    it 'returns true if the plan has a trial period' do
      plan.trial_period_days = 7

      expect(plan.trial?).to eq(true)
    end

    it 'returns false if the plan does not have a trial period' do
      plan.trial_period_days = 0

      expect(plan.trial?).to eq(false)
    end

    it 'returns false if the plan\'s trial period is nil' do
      plan.trial_period_days = nil

      expect(plan.trial?).to eq(false)
    end
  end

  describe '#stripe?' do
    it 'returns true if the plan has a Stripe ID' do
      plan.stripe_id = 'plan_123'

      expect(plan.stripe?).to eq(true)
    end

    it 'returns false if the plan does not have a Stripe ID' do
      plan.stripe_id = nil

      expect(plan.stripe?).to eq(false)
    end
  end
end
