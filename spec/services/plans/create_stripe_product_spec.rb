require 'rails_helper'

RSpec.describe Plans::CreateStripeProduct, type: :service do
  let!(:plan) { create(:plan) }
  subject { described_class.call(plan: plan) }
  let!(:stripe_mock) { Mock::Stripe.new }

  context 'when the product already exists' do
    let!(:stripe_mock) { Mock::Stripe.new(products: 1) }
    let!(:plan) { create(:plan, name: stripe_mock.products.first['name']) }

    it 'does not create a new product' do
      expect(Stripe::Product).not_to receive(:create)
      subject
    end
  end

  context 'when the product does not exist' do
    let!(:stripe_mock) { Mock::Stripe.new(products: 0) }
    let!(:plan) { create(:plan) }

    it 'creates a new product' do
      expect(Stripe::Product).to receive(:create).with(name: "#{plan.name} Plan")
      subject
    end
  end

  it 'creates a new price' do
    product_id = stripe_mock.products.first['id']
    expect(Stripe::Price).to receive(:create).with(
      {
        unit_amount: plan.amount,
        currency: plan.currency,
        recurring: { interval: plan.interval == 'monthly' ? 'month' : 'year' },
        product: product_id
      }
    )
    subject
  end

  it 'updates the plan with the stripe id' do
    stripe_id = stripe_mock.prices.first['id']
    expect { subject }.to change { plan.reload.stripe_id }.from(nil).to(stripe_id)
  end

  it 'returns the stripe price' do
    result = subject
    expect(result.success?).to be_truthy
    expect(result.price).to be_instance_of(Stripe::Price)
  end
end
