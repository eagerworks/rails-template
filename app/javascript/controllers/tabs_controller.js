import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["tab"];
  static classes = ["selected"];

  deselectedClasses = [
    "border-transparent",
    "text-gray-500",
    "hover:border-gray-300",
    "hover:text-gray-700",
  ];

  connect() {
    this.selectTabByIndex(0);
  }

  selectTab(event) {
    const tabIndex = this.tabTargets.indexOf(event.target);
    this.selectTabByIndex(tabIndex);
  }

  selectTabByIndex(index) {
    this.deselectAll();
    const selectedTab = this.tabTargets[index];
    selectedTab.setAttribute("tabindex", "0");
    selectedTab.setAttribute("aria-selected", "true");
    selectedTab.classList.remove(...this.deselectedClasses);
    selectedTab.classList.add(...this.selectedClasses);
  }

  deselectAll() {
    this.tabTargets.forEach((tab) => {
      tab.setAttribute("tabindex", "-1");
      tab.setAttribute("aria-selected", "false");
      tab.classList.remove(...this.selectedClasses);
      tab.classList.add(...this.deselectedClasses);
    });
  }
}
