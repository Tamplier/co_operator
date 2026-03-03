import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.open();
  }

  open() {
    this.element.classList.remove("hidden");
  }

  close() {
    this.element.classList.add("hidden");
  }
}
