require 'rails_helper'

RSpec.describe Subscriptions::CheckPayment, type: :service do
  let!(:user) { create(:user) }
  let!(:account) { create(:account) }
  let(:session_id) { 'cs_test_123' }
  subject { described_class.call(session_id: session_id, user: user, account: account) }
  let!(:stripe_mock) { Mock::Stripe.new }
  let(:stripe_subscription) { stripe_mock.subscriptions.first }
  let!(:plan) { create(:plan, stripe_id: stripe_subscription['plan']['id']) }
  let!(:customer) { stripe_mock.customers.first }

  context 'when the session status is not complete' do
    let!(:stripe_mock) { Mock::Stripe.new(session_status: 'incomplete') }

    it 'returns a failure' do
      expect(subject.error).to eq('The payment failed or was canceled.')
      expect(subject.success?).to be_falsey
    end

    it 'does not update the user' do
      expect { subject }.not_to change { user.reload.stripe_id }
    end

    it 'does not create a subscription' do
      expect { subject }.not_to change { Subscription.count }
    end
  end

  context 'when the session status is complete' do
    it 'returns a success' do
      expect(subject.error).to be_nil
      expect(subject.success?).to be_truthy
      expect(subject.payload).to be_instance_of(Subscription)

      subscription = subject.payload

      expect(subscription.plan).to eq(plan)
      expect(subscription.account).to eq(account)
      expect(subscription.quantity).to eq(stripe_subscription['quantity'])
      expect(subscription.ends_at).to eq(Time.at(stripe_subscription['current_period_end']))
      expect(subscription.stripe_id).to eq(stripe_subscription['id'])
    end

    it 'updates the user' do
      expect { subject }.to change { user.reload.stripe_id }.from(nil).to(customer['id'])
    end

    it 'creates a subscription' do
      expect { subject }.to change { Subscription.count }.by(1)
    end

    context 'with a trial' do
      let!(:stripe_mock) { Mock::Stripe.new(subscription_trial: true) }

      it 'sets the trial_ends_at date' do
        trial_end = Time.at(stripe_subscription['trial_end'])
        subscription = subject.payload
        expect(subscription.trial_ends_at).to eq(trial_end)
      end
    end

    context 'without a trial' do
      let!(:stripe_mock) { Mock::Stripe.new(subscription_trial: false) }

      it 'does not set the trial_ends_at date' do
        subscription = subject.payload
        expect(subscription.trial_ends_at).to be_nil
      end
    end
  end
end
