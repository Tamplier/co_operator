import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static classes = ["open", "hidden"];
  static targets = ["sidebar", "overlay"];

  toggle() {
    this.sidebarTarget.classList.toggle(this.openClass);
    this.overlayTarget.classList.toggle(this.hiddenClass);
  }
}
