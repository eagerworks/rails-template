import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search-form"
export default class extends Controller {
  search(event) {
    event.stopPropagation();
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      // update url params with search query
      const params = new URLSearchParams(window.location.search);

      this.element.requestSubmit();
    }, 200);
  }
}
