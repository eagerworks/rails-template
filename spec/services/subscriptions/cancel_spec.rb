require 'rails_helper'

RSpec.describe Subscriptions::Cancel, type: :service do
  let!(:subscription) { create(:subscription) }
  subject { described_class.call(subscription) }
  let!(:stripe_mock) { Mock::Stripe.new }

  it 'cancels the subscription' do
    expect(Stripe::Subscription).to receive(:update).with(subscription.stripe_id,
                                                          { cancel_at_period_end: true })
    subject
  end

  it 'sets the ends_at date' do
    current_period_end = stripe_mock.subscriptions.first['current_period_end']
    expect { subject }.to change {
      subscription.reload.ends_at
    }.from(nil).to(Time.at(current_period_end))
  end

  it 'sets the subscription status to canceled' do
    expect { subject }.to change { subscription.reload.status }.from('active').to('canceled')
  end

  it 'returns the subscription' do
    result = subject
    expect(result.error).to be_nil
    expect(result.success?).to be_truthy
    expect(result.payload).to be_instance_of(Subscription)
  end
end
