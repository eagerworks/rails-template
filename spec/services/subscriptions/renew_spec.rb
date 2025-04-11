require 'rails_helper'

RSpec.describe Subscriptions::Renew, type: :service do
  subject { described_class.call(subscription: subscription) }
  let!(:stripe_mock) { Mock::Stripe.new }

  context 'when the subscription has already ended' do
    let!(:subscription) { create(:subscription, :ended) }

    it 'returns a failure' do
      expect(subject.error).to eq('Subscription has already ended.')
      expect(subject.success?).to be_falsey
    end

    it 'does not update the subscription' do
      subject

      expect(subscription.reload.active?).to be_falsey
      expect(subscription.ends_at).to be_present
    end

    it 'does not call the Stripe API' do
      expect(Stripe::Subscription).not_to receive(:update)

      subject
    end
  end

  shared_examples 'renews the subscription' do
    it 'renews the subscription' do
      expect(Stripe::Subscription).to receive(:update).with(subscription.stripe_id,
                                                            { cancel_at_period_end: false })

      subject
    end

    it 'updates the subscription' do
      subject

      expect(subscription.reload.active?).to be_truthy
      expect(subscription.ends_at).to be_nil
    end

    it 'returns a success' do
      expect(subject.error).to be_nil
      expect(subject.success?).to be_truthy
    end

    it 'returns the subscription' do
      expect(subject.subscription).to eq(subscription)
    end
  end

  context 'when the subscription is active' do
    let!(:subscription) { create(:subscription, :active) }

    include_examples 'renews the subscription'
  end

  context 'when the subscription is on grace period' do
    let!(:subscription) { create(:subscription, :on_grace_period) }

    include_examples 'renews the subscription'
  end
end
