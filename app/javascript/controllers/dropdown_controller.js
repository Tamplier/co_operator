import { Controller } from "@hotwired/stimulus";
import { useDebounce } from "stimulus-use"
import SlimSelect from "slim-select"

export default class extends Controller {
  static values = { path: String, inline: Boolean, placeholder: { type: String, default: 'Select Value' } };

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
        },
        ...(this.hasPathValue && {
          search: (searchValue, currentData) => this.search(searchValue)
        })
      }
    })
  }

  disconnect() {
    this.select?.destroy()
  }

  search(searchValue) {
    if (!this.hasPathValue || searchValue.length < 3) return Promise.resolve([]);
    clearTimeout(this._searchTimer)

    return new Promise((resolve, reject) => {
      this._searchTimer = setTimeout(() => {
        fetch(`${this.pathValue}?query=${searchValue}`)
          .then(res => res.json())
          .then(json => {
            const data = json.map(item => ({
              value: String(item.id),
              text: item.title,
              html: item.html
            }))
            resolve(data)
          }).catch(() => reject('Search Error'))
      }, 300)
    })
  }
}
