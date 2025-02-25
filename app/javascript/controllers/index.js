import Alpine from "alpinejs";
import copyButton from "./copy_button.js";
import dropdown from "./dropdown.js";
import imageInput from "./image_input.js";
import modal from "./modal.js";
import passkey from "./passkey.js";
import stripeCheckout from "./stripe_checkout.js";

Alpine.data("copyButton", copyButton);
Alpine.data("dropdown", dropdown);
Alpine.data("imageInput", imageInput);
Alpine.data("modal", modal);
Alpine.data("passkey", passkey);
Alpine.data("stripeCheckout", stripeCheckout);

Alpine.start();
