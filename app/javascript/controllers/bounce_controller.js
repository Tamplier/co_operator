import { Controller } from "@hotwired/stimulus"

const BOUNCE_DURATION = 400
const BOUNCE_CLASS = 'bounce'

export default class extends Controller {
  trigger() {
    this.element.classList.remove(BOUNCE_CLASS)
    void this.element.offsetWidth; // reflow
    this.element.classList.add(BOUNCE_CLASS);
    setTimeout(() => this.element.classList.remove(BOUNCE_CLASS), BOUNCE_DURATION);
  }
}
