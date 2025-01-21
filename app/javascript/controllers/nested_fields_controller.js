import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="nested-fields"
export default class extends Controller {
  static values = { persisted: Boolean };
  static targets = ["destroyField"];

  destroy() {
    if (this.persistedValue) {
      this.destroyFieldTarget.value = "1";
      this.element.classList.add("hidden");
    } else {
      this.element.remove();
    }
  }
}
