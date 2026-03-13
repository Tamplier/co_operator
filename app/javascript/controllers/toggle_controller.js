import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"];
  static values = { classes: { type: Array, default: ["hidden"] } }

  toggle() {
    this.itemTargets.forEach(element => {
      this.classesValue.forEach(className => {
        element.classList.toggle(className);
      });
    });
  }
}
