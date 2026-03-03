import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.submitStart = this.submitStart.bind(this);
    window.addEventListener("turbo:submit-start", this.submitStart);
  }

  disconnect() {
    this.element.removeEventListener("turbo:submit-start", this.submitStart);
  }

  disableAllButtons() {
    this.element.querySelectorAll('button').forEach(element => {
      element.disabled = true;
    });
  }

  submitStart(event) {
    this.disableAllButtons()
    const button = event.detail.formSubmission.submitter || this.getSpinnterTarget();
    if (!button) return;

    this.button = button;

    this.originalHTML = button.innerHTML;
    this.originalWidth = button.offsetWidth;

    button.style.minWidth = `${this.originalWidth}px`;

    button.disabled = true;

    button.innerHTML = `
      <span class="spinner_container">
        ${this.spinnerSVG()}
      </span>
    `;
  }

  getSpinnterTarget() {}

  spinnerSVG() {
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
