import { Controller } from "@hotwired/stimulus"
import { useDebounce } from "stimulus-use"

export default class extends Controller {
  static debounces = ["search"]
  static targets = ["results", "form"]

  connect() {
    useDebounce(this, { wait: 300 })
  }

  search(event) {
    if (event.target.value.length >= 3) this.formTarget.requestSubmit();
  }
}
