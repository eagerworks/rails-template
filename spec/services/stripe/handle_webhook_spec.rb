require 'rails_helper'

RSpec.describe Stripe::HandleWebhook, type: :service do
  let(:event) do
    Stripe::Event.construct_from({
                                   id: 'evt_123',
                                   object: 'event',
                                   type: 'customer.subscription.deleted',
                                   data: {
                                     object: {
                                       id: 'sub_123',
                                       status: 'canceled',
                                       current_period_end: Time.now.to_i
                                     }
                                   }
                                 })
  end
  let(:stripe_subscription) { event.data.object }

  subject { described_class.call(event: event) }

  before do
    allow(Subscription).to receive(:find_by!).with(stripe_id: stripe_subscription.id)
                                             .and_return(subscription)
  end

  let!(:subscription) { create(:subscription, stripe_id: stripe_subscription.id, status: 'active') }

  describe '#call' do
    it 'updates the subscription status to canceled' do
      expect(subscription).to receive(:update!).with(
        status: 'canceled', ends_at: Time.at(stripe_subscription.current_period_end)
      )
      subject
    end

    it 'returns a success context' do
      expect(subject).to be_success
    end

    context 'when the subscription is resumed' do
      let(:event) do
        Stripe::Event.construct_from({
                                       id: 'evt_123',
                                       object: 'event',
                                       type: 'customer.subscription.resumed',
                                       data: {
                                         object: {
                                           id: 'sub_123',
                                           status: 'active'
                                         }
                                       }
                                     })
      end

      it 'sets ends_at to nil' do
        expect(subscription).to receive(:update!).with(status: 'active', ends_at: nil)
        subject
      end
    end

    context 'when the subscription is not found' do
      before do
        allow(Subscription).to receive(:find_by!).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'fails with an error message' do
        expect(subject.success?).to eq(false)
        expect(subject.error).to eq('Subscription not found.')
      end
    end
  end
end
