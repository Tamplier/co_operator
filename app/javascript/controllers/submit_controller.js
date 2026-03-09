import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["spinner"];

  initialize() {
    this.submitStart = this.submitStart.bind(this);
    this.submitEnd = this.submitEnd.bind(this);
  }

  connect() {
    this.wasButtonHidden = false;
    this.element.addEventListener("turbo:submit-start", this.submitStart);
    this.element.addEventListener("turbo:submit-end", this.submitEnd);
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-start", this.submitStart);
    this.element.removeEventListener("turbo:submit-end", this.submitEnd);
  };

  submitEnd(event) {
    this.#toggleAllButtons()
    if (this.wasButtonHidden) {
      const button = this.#getSpinnerTarget(event);
      button.classList.add("hidden");
    }
  }

  submitStart(event) {
    const button = this.#getSpinnerTarget(event);
    if (!button) return;

    this.#toggleAllButtons()
    this.button = button;
    this.originalWidth = button.offsetWidth;
    button.style.minWidth = `${this.originalWidth}px`;
    button.disabled = true;
    this.wasButtonHidden = button.classList.contains("hidden") || this.wasButtonHidden;
    button.classList.remove("hidden");

    button.innerHTML = `<span class="spinner_container">${this.#spinnerSVG()}</span>`;
  }

  #toggleAllButtons() {
    this.element.querySelectorAll('button').forEach(element => {
      element.disabled = !element.disabled;
    });
  }

  #getSpinnerTarget(event) {
    return this.hasSpinnerTarget
      ? this.spinnerTarget
      : event.detail.formSubmission.submitter;
  }

  #spinnerSVG() {
    return `
      <svg fill="none" viewBox="0 0 24 24">
        <circle cx="12" cy="12" r="10"
                stroke="currentColor"
                stroke-width="4"/>
        <path fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"/>
      </svg>
    `;
  }
}
