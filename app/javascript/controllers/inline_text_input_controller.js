import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form", "label"];

  toggle() {
    const parent = this.element.parentNode;
    const input = this.formTarget.querySelector("input");
    const error = parent.querySelector(".error");

    this.formTarget.classList.toggle("hidden");
    this.labelTarget.classList.toggle("hidden");
    if (error) {
      error.remove();
      parent.classList.remove("field_with_errors");
      input.value = this.labelTarget.textContent;
    }
  }
}
