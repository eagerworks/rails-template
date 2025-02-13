import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["backdrop", "panel"];
  backdropOpenClasses = ["opacity-100", "ease-out", "duration-300"];
  backdropCloseClasses = ["opacity-0", "ease-in", "duration-200"];
  panelOpenClasses = [
    "ease-out",
    "duration-300",
    "opacity-100",
    "translate-y-0",
    "sm:scale-100",
  ];
  panelCloseClasses = [
    "ease-in",
    "duration-200",
    "opacity-0",
    "translate-y-4",
    "sm:translate-y-0",
    "sm:scale-95",
  ];

  connect() {
    this.backdropTarget.classList.add(...this.backdropCloseClasses);
    this.panelTarget.classList.add(...this.panelCloseClasses);
  }

  open() {
    this.backdropTarget.classList.remove("hidden");
    this.panelTarget.classList.remove("hidden");
    setTimeout(() => {
      this.backdropTarget.classList.remove(...this.backdropCloseClasses);
      this.backdropTarget.classList.add(...this.backdropOpenClasses);
      this.panelTarget.classList.remove(...this.panelCloseClasses);
      this.panelTarget.classList.add(...this.panelOpenClasses);
    }, 0);
  }

  close() {
    this.backdropTarget.classList.remove(...this.backdropOpenClasses);
    this.backdropTarget.classList.add(...this.backdropCloseClasses);
    this.panelTarget.classList.remove(...this.panelOpenClasses);
    this.panelTarget.classList.add(...this.panelCloseClasses);
    setTimeout(() => {
      this.backdropTarget.classList.add("hidden");
      this.panelTarget.classList.add("hidden");
    }, 200);
  }

  handleFormSubmit(event) {
    if (event.detail.success) {
      this.close();
    }
  }
}
