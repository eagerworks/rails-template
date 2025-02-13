import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="stripe-checkout"
export default class extends Controller {
  static targets = ["checkout"];
  static values = { sessionUrl: String, publicKey: String };

  connect() {
    const stripe = Stripe(this.publicKeyValue);

    const fetchClientSecret = async () => {
      const response = await fetch(this.sessionUrlValue, {
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
        checkout.mount(this.checkoutTarget);
      });
  }
}
