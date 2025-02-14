export default (publicKey, sessionUrl) => ({
  init() {
    const stripe = Stripe(publicKey);

    const fetchClientSecret = async () => {
      const response = await fetch(sessionUrl, {
        method: "POST",
      });
      const { clientSecret } = await response.json();
      return clientSecret;
    };

    // Initialize Checkout
    stripe
      .initEmbeddedCheckout({
        fetchClientSecret,
      })
      .then((checkout) => {
        // Mount Checkout
        checkout.mount(this.$el);
      });
  },
});
