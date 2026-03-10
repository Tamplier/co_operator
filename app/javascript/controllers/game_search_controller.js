import { useDebounce } from "stimulus-use"
import SubmitController from "controllers/submit_controller"

export default class extends SubmitController {
  static debounces = ["search"]
  static targets = ["details", "form", "counter", "countCountainer"]

  connect() {
    super.connect();
    useDebounce(this, { wait: 300 });

    this.observer = new MutationObserver(() => this.updateCounter());
    if (!this.hasCounterTarget) return;

    this.observer.observe(
      this.countCountainerTarget,
      { childList: true }
    )
  }

  disconnect() {
    this.observer.disconnect()
  }

  search(event) {
    if (event.target.value.length >= 3) {
      this.formTarget.requestSubmit();
      if (this.hasDetailsTarget) this.detailsTarget.open = true;
    }
  }

  updateCounter() {
    if (!this.hasCounterTarget) return;

    const bounceController = this.application.getControllerForElementAndIdentifier(this.counterTarget, "bounce");
    const games = this.countCountainerTarget.querySelectorAll(":scope > div");
    this.counterTarget.textContent = games.length;
    if (bounceController) bounceController.trigger()
  }
}
