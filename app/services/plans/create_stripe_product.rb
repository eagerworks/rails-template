module Plans
  class CreateStripeProduct
    include Interactor

    def call
      context.plan.update!(stripe_id: price.id)
    end

    private

    def product
      return @product if @product.present?

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

    def product_name
      "#{context.plan.name} Plan"
    end

    def price
      context.price ||= Stripe::Price.create({
                                               unit_amount: context.plan.amount,
                                               currency: context.plan.currency,
                                               recurring: { interval: interval },
                                               product: product.id
                                             })
    end

    def interval
      context.plan.interval == 'monthly' ? 'month' : 'year'
    end
  end
end
