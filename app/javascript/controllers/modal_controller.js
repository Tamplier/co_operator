import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.open();
  }

  disconnect() {}

  close() {
    this.element.classList.add("hidden");
    window.dispatchEvent(new CustomEvent("modal:closed"));
    // Clear the turbo-frame source and remove the element to prevent issues with the next modal
    const turboFrame = document.querySelector('turbo-frame[id="modal"]');
    if (turboFrame) {
      turboFrame.src = null;
      turboFrame.innerHTML = "";
    }
  }

  backdropClick() {
    if (!this.#isMobile()) {
      this.close();
    }
  }

  open() {
    this.element.classList.remove("hidden");
  }

  #isMobile() {
    return window.matchMedia("(max-width: 640px)").matches;
  }
}
