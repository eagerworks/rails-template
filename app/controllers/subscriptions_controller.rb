class SubscriptionsController < ApplicationController
  before_action :require_current_account_admin!
  before_action :load_plan, only: [:new, :sessions]
  before_action :load_subscription, only: [:update, :index]
  skip_before_action :verify_authenticity_token, only: [:sessions]

  layout 'settings', only: [:index]

  def index
    skip_policy_scope

    authorize @subscription, :show?
  end

  def new
    @subscription = @plan.subscriptions.build

    authorize @subscription
  end

  def sessions
    render json: { clientSecret: checkout_session.client_secret }
  end

  def update
    result = Subscriptions::Update.call(subscription: @subscription, params: subscription_params)

    if result.success?
      redirect_to subscriptions_path, notice: 'Subscription updated.'
    else
      redirect_to subscriptions_path, alert: result.error
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:plan_id)
  end

  def checkout_session
    Stripe::Checkout::Session.create({
                                       mode: 'subscription',
                                       line_items: [
                                         {
                                           price: plan_stripe_id,
                                           quantity: 1
                                         }
                                       ],
                                       customer: current_user.stripe_id,
                                       ui_mode: 'embedded',
                                       return_url: return_url,
                                       allow_promotion_codes: true,
                                       client_reference_id: @plan.id,
                                       subscription_data: subscription_data
                                     })
  end

  def subscription_data
    trial_allowed = Current.account.subscription.blank?

    {
      metadata: params.fetch(:metadata, {}).permit!.to_h,
      trial_settings: { end_behavior: { missing_payment_method: 'pause' } },
      trial_period_days: (@plan.trial? && trial_allowed ? @plan.trial_period_days : nil)
    }.compact
  end

  def return_url
    "#{checkout_return_url(return_to: root_url)}&session_id={CHECKOUT_SESSION_ID}"
  end

  def plan_stripe_id
    if @plan.stripe?
      @plan.stripe_id
    else
      result = ::Plans::CreateStripeProduct.call!(plan: @plan)
      result.price.id
    end
  end

  def load_plan
    @plan = Plan.find(params[:plan_id])

    authorize @plan, :show?
  end

  def load_subscription
    @subscription = Current.account.subscription

    unless @subscription.present?
      redirect_back fallback_location: root_path, alert: 'You do not have a subscription.'

      return
    end

    authorize @subscription
  end
end
