import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select"

export default class extends Controller {
  static values = { inline: Boolean, placeholder: { type: String, default: 'Select Value' } }

  connect() {
    this.form = this.element.closest("form");
    this.select = new SlimSelect({
      select: this.element,
      showSearch: true,
      settings: {
        placeholderText: this.placeholderValue,
      },
      events: {
        afterChange: (newVal) => {
          if (!this.inlineValue) return;
          this.form.requestSubmit();
        }
      }
    })
  }

  disconnect() {
    this.select?.destroy()
  }
}
