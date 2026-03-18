import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select"

export default class extends Controller {
  connect() {
    this.form = this.element.closest("form");
    this.select = new SlimSelect({
      select: this.element,
      showSearch: true,
      events: {
        afterChange: (newVal) => {
          this.form.requestSubmit();
        }
      }
    })
  }

  disconnect() {
    this.select?.destroy()
  }
}
