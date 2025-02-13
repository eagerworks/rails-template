module Plans
  class CreateStripeProduct < ApplicationService
    def call(plan:)
      @plan = plan
      plan.update!(stripe_id: price.id)

      success(price)
    end

    private

    def product
      return @product if @product.present?

      product_name = "#{@plan.name} Plan"

      # Search for existing product
      products = Stripe::Product.search(limit: 1,
                                        query: "active:'true' AND name:'#{product_name}'")

      @product = if products.data.any?
                   products.data.first
                 else
                   Stripe::Product.create(name: product_name)
                 end

      @product
    end

    def price
      @price ||= Stripe::Price.create({
                                        unit_amount: @plan.amount,
                                        currency: @plan.currency,
                                        recurring: { interval: interval },
                                        product: product.id
                                      })
    end

    def interval
      @plan.interval == 'monthly' ? 'month' : 'year'
    end
  end
end
