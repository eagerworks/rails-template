import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="image-input"
export default class extends Controller {
  static targets = ["image", "placeholder"];

  changeImage(event) {
    const file = event.target.files[0];

    const reader = new FileReader();

    reader.onload = (event) => {
      this.imageTarget.src = event.target.result;
      this.imageTarget.classList.remove("hidden");

      if (this.hasPlaceholderTarget) {
        this.placeholderTarget.classList.add("hidden");
      }
    };

    reader.readAsDataURL(file);
  }
}
