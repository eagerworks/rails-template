require 'rails_helper'

RSpec.describe Subscriptions::Update, type: :service do
  let(:subscription) { create(:subscription) }
  let(:plan) { create(:plan) }
  let(:params) { { plan_id: plan.id } }
  subject { described_class.call(subscription: subscription, params: params) }
  let!(:stripe_mock) { Mock::Stripe.new }
  let(:stripe_subscription) { stripe_mock.subscriptions.first }
  let!(:subscription_item) { stripe_mock.subscription_items.first }

  it 'updates the stripe plan' do
    expect(Stripe::Subscription).to receive(:update).with(subscription.stripe_id, {
                                                            items: [
                                                              {
                                                                id: subscription_item['id'],
                                                                price: plan.stripe_id
                                                              }
                                                            ],
                                                            trial_end: 'now'
                                                          })

    subject
  end

  it 'updates the subscription' do
    subject

    expect(subscription.reload.plan).to eq(plan)
    expect(subscription.status).to eq(stripe_subscription['status'])
  end

  it 'returns a success' do
    expect(subject.error).to be_nil
    expect(subject.success?).to be_truthy
  end

  it 'returns the subscription' do
    expect(subject.subscription).to eq(subscription)
  end

  context 'when the plan has a trial' do
    let(:plan) { create(:plan, :trial) }

    it 'updates the stripe plan with a trial end date' do
      expect(Stripe::Subscription).to receive(:update).with(
        subscription.stripe_id, {
          items: [
            {
              id: subscription_item['id'],
              price: plan.stripe_id
            }
          ],
          trial_end: (subscription.created_at + plan.trial_period_days.days).to_i
        }
      )

      subject
    end

    it 'updates the subscription' do
      subject

      expected_date = subscription.created_at + plan.trial_period_days.days
      expect(subscription.reload.trial_ends_at).to eq(expected_date)
    end
  end
end
