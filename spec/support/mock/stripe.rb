module Mock
  class Stripe
    include RSpec::Mocks::ExampleMethods

    attr_reader :products, :prices, :subscriptions, :customers, :subscription_items

    def initialize(products: 0, session_status: 'complete', subscription_trial: false)
      load_fixture
      load_subscription_dates(subscription_trial)
      @product_amount = products
      @session_status = session_status

      mock_products
      mock_prices
      mock_subscriptions
      mock_sessions
      mock_customers
      mock_subscription_items
    end

    private

    def load_fixture
      data = YAML.load_file('spec/support/mock/fixtures/stripe.yml')
      @products = data['products']
      @prices = data['prices']
      @customers = data['customers']
      @subscription_items = data['subscription_items']
      @subscriptions = data['subscriptions']
    end

    def load_subscription_dates(subscription_trial)
      @subscriptions.each do |subscription|
        subscription['current_period_end'] = Time.now.end_of_month.to_i
        subscription['trial_end'] = subscription_trial ? Time.now.end_of_month.to_i : nil
      end
    end

    def mock_products
      allow(::Stripe::Product).to receive(:search).and_return(
        ::Stripe::SearchResultObject.construct_from(
          {
            data: @products.first(@product_amount).map do |product|
              ::Stripe::Product.construct_from(product)
            end
          }
        )
      )

      allow(::Stripe::Product).to receive(:create).and_return(
        ::Stripe::Product.construct_from(@products.first)
      )
    end

    def mock_prices
      allow(::Stripe::Price).to receive(:create).and_return(
        ::Stripe::Price.construct_from(@prices.first)
      )
    end

    def mock_subscriptions
      allow(::Stripe::Subscription).to receive(:update).and_return(
        ::Stripe::Subscription.construct_from(@subscriptions.first)
      )

      allow(::Stripe::Subscription).to receive(:retrieve).and_return(
        ::Stripe::Subscription.construct_from(@subscriptions.first)
      )
    end

    def mock_sessions
      allow(::Stripe::Checkout::Session).to receive(:retrieve).and_return(
        ::Stripe::Checkout::Session.construct_from({
                                                     status: @session_status,
                                                     customer: @customers.first['id'],
                                                     subscription: @subscriptions.first['id']
                                                   })
      )
    end

    def mock_customers
      allow(::Stripe::Customer).to receive(:retrieve).and_return(
        ::Stripe::Customer.construct_from(@customers.first)
      )
    end

    def mock_subscription_items
      allow(::Stripe::SubscriptionItem).to receive(:list).and_return(
        ::Stripe::ListObject.construct_from(
          {
            data: @subscription_items.map do |subscription_item|
              ::Stripe::SubscriptionItem.construct_from(subscription_item)
            end
          }
        )
      )
    end
  end
end
