import { useDebounce } from "stimulus-use"
import SubmitController from "controllers/submit_controller"

export default class extends SubmitController {
  static debounces = ["search"]
  static targets = ["details", "resultsLoader", "form", "counter", "countCountainer"]

  connect() {
    super.connect();
    useDebounce(this, { wait: 300 });

    this.updateCounter();
    this.observer = new MutationObserver(() => this.updateCounter());
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

  getSpinnterTarget() {
    return this.resultsLoaderTarget;
  }

  updateCounter() {
    if (!this.counterTarget) return;

    const games = this.countCountainerTarget.querySelectorAll(":scope > div")
    this.counterTarget.textContent = games.length
  }
}
