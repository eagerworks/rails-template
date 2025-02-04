import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="copy-button"
export default class extends Controller {
  static values = { text: String };

  copy(event) {
    navigator.clipboard.writeText(this.textValue);
    const originalText = event.target.innerText;
    event.target.innerText = "Copied!";

    setTimeout(() => {
      event.target.innerText = originalText;
    }, 1000);
  }
}
