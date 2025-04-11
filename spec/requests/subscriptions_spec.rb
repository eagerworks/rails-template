require 'rails_helper'

RSpec.describe 'Subscriptions', type: :request do
  let(:user) { create(:user, :admin) }
  let(:account) { create(:account_user, user: user, role: :admin).account }
  let(:plan) { create(:plan) }
  let!(:subscription) { create(:subscription, account: account, plan: plan) }

  before do
    sign_in user
    Current.account = account
  end

  describe 'GET /index' do
    subject { get subscriptions_path }

    context 'when user has a subscription' do
      before { subscription }

      it 'renders the index template' do
        subject
        expect(response).to render_template(:index)
      end

      it 'authorizes the subscription' do
        expect_any_instance_of(SubscriptionPolicy).to receive(:show?).and_return(true)
        subject
      end
    end

    context 'when user has no subscription' do
      let(:account) { create(:account) }

      it 'redirects to root path' do
        subject
        expect(response).to redirect_to(root_path)
      end

      it 'sets an alert message' do
        subject
        expect(flash[:alert]).to eq('You do not have a subscription.')
      end
    end

    context 'when not authenticated' do
      before { sign_out user }

      it 'redirects to sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET /new' do
    subject { get new_plan_subscription_path(plan_id: plan.id) }

    it 'renders the new template' do
      subject
      expect(response).to render_template(:new)
    end

    it 'builds a new subscription for the plan' do
      subject
      expect(assigns(:subscription)).to be_a_new(Subscription)
      expect(assigns(:subscription).plan).to eq(plan)
    end

    it 'authorizes the subscription' do
      expect_any_instance_of(SubscriptionPolicy).to receive(:new?).and_return(true)
      subject
    end

    context 'when not authenticated' do
      before { sign_out user }

      it 'redirects to sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /sessions' do
    subject { post sessions_plan_subscriptions_path(plan_id: plan.id) }

    let(:stripe_session) { double(client_secret: 'secret') }

    before do
      allow(Stripe::Checkout::Session).to receive(:create).and_return(stripe_session)
    end

    it 'creates a Stripe checkout session' do
      expect(Stripe::Checkout::Session).to receive(:create).with(
        hash_including(
          mode: 'subscription',
          customer: user.stripe_id,
          ui_mode: 'embedded',
          allow_promotion_codes: true,
          client_reference_id: plan.id
        )
      )
      subject
    end

    it 'returns the client secret' do
      subject
      expect(JSON.parse(response.body)).to eq({ 'clientSecret' => 'secret' })
    end

    context 'when plan is not a Stripe plan' do
      let(:stripe_product) { double(id: 'stripe_id') }

      before do
        allow(Plans::CreateStripeProduct).to receive(:call!).and_return(
          double(price: stripe_product)
        )
      end

      it 'creates a Stripe product first' do
        expect(Plans::CreateStripeProduct).to receive(:call!).with(plan: plan)
        subject
      end

      it 'uses the created Stripe product ID' do
        expect(Stripe::Checkout::Session).to receive(:create).with(
          hash_including(line_items: [{ price: 'stripe_id', quantity: 1 }])
        )
        subject
      end
    end

    context 'when not authenticated' do
      before { sign_out user }

      it 'redirects to sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /update' do
    subject { patch subscription_path(subscription), params: params }

    let(:params) { { subscription: { plan_id: plan.id } } }

    context 'when update is successful' do
      before do
        allow(Subscriptions::Update).to receive(:call).and_return(double(success?: true))
      end

      it 'redirects to subscriptions path' do
        subject
        expect(response).to redirect_to(subscriptions_path)
      end

      it 'sets a success notice' do
        subject
        expect(flash[:notice]).to eq('Subscription updated.')
      end
    end

    context 'when update fails' do
      before do
        allow(Subscriptions::Update).to receive(:call).and_return(double(success?: false,
                                                                         error: 'Error'))
      end

      it 'redirects to subscriptions path' do
        subject
        expect(response).to redirect_to(subscriptions_path)
      end

      it 'sets an error message' do
        subject
        expect(flash[:alert]).to eq('Error')
      end
    end

    context 'when not authenticated' do
      before { sign_out user }

      it 'redirects to sign in page' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
