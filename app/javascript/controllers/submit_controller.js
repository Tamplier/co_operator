import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["spinner"];
  static values = { wrapperClasses: Array, directInjection: { type: Boolean, default: false } };

  initialize() {
    this.submitStart = this.submitStart.bind(this);
    this.submitEnd = this.submitEnd.bind(this);
  }

  connect() {
    this.element.addEventListener("turbo:submit-start", this.submitStart);
    this.element.addEventListener("turbo:submit-end", this.submitEnd);
    this.#connectWrapper();
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-start", this.submitStart);
    this.element.removeEventListener("turbo:submit-end", this.submitEnd);
  };

  submitEnd(event) {
    this.#toggleAllButtons()
    if (this.wasTargetHidden) {
      const target = this.#getSpinnerTarget(event);
      target.classList.add("hidden");
    }
  }

  submitStart(event) {
    const target = this.#getSpinnerTarget(event);
    if (!target) return;

    this.#toggleAllButtons()
    this.target = target;
    this.originalWidth = target.offsetWidth;
    target.style.minWidth = `${this.originalWidth}px`;
    target.disabled = true;
    this.wasTargetHidden = target.classList.contains("hidden") || this.wasTargetHidden;
    target.classList.remove("hidden");

    target.innerHTML = `<span class="spinner_container">${this.#spinnerSVG()}</span>`;
  }

  #toggleAllButtons() {
    this.element.querySelectorAll('button').forEach(element => {
      element.disabled = !element.disabled;
    });
  }

  #connectWrapper() {
    if (!this.hasSpinnerTarget) { this.target = null; }
    else {
      if (this.directInjectionValue) {
        this.target = this.spinnerTarget;
        return;
      }

      this.target = document.createElement('div');
      this.target.classList.add('spinner_wrapper', 'hidden');
      if (this.wrapperClassesValue.length > 0) this.target.classList.add(...this.wrapperClassesValue);
      this.spinnerTarget.append('', this.target)
    }
  }

  #getSpinnerTarget(event) {
    return this.target || event.detail.formSubmission.submitter;
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
