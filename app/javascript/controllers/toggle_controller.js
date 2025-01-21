import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "button", "thumb"];
  static values = {
    checked: Boolean,
  };
  static classes = ["checked"];

  connect() {
    this.checked = this.checkedValue;
    this.changeValue();
  }

  toggle() {
    this.checked = !this.checked;
    this.changeValue();
    this.buttonTarget.focus();
  }

  changeValue() {
    this.inputTarget.value = this.checked;
    this.buttonTarget.setAttribute("aria-checked", this.checked);
    this.buttonTarget.classList.toggle(this.checkedClass, this.checked);
    this.buttonTarget.classList.toggle("bg-gray-200", !this.checked);
    this.thumbTarget.classList.toggle("translate-x-5", this.checked);
    this.thumbTarget.classList.toggle("translate-x-0", !this.checked);
  }
}
