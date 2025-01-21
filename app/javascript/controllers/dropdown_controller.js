import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dropdown", "button"];

  connect() {
    this.open = false;
  }

  toggle() {
    this.open = !this.open;

    if (this.open) {
      this.openDropdown();
    } else {
      this.closeDropdown();
    }
  }

  removeFocus(event) {
    if (!this.element.contains(event.target)) {
      this.open = false;
      this.closeDropdown();
    }
  }

  openDropdown() {
    this.dropdownTarget.classList.remove("hidden");
    this.buttonTarget.focus();
    this.buttonTarget.setAttribute("aria-expanded", true);

    setTimeout(() => {
      this.dropdownTarget.classList.remove("opacity-0", "scale-95");
      this.dropdownTarget.classList.add("opacity-100", "scale-100");
    }, 1);
  }

  closeDropdown() {
    this.dropdownTarget.classList.remove("opacity-100", "scale-100");
    this.dropdownTarget.classList.add("opacity-0", "scale-95");

    setTimeout(() => {
      this.dropdownTarget.classList.add("hidden");
    }, 100);
    this.buttonTarget.setAttribute("aria-expanded", false);
  }
}
