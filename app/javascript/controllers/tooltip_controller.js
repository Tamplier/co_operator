import { Controller } from "@hotwired/stimulus";
import { computePosition, offset, arrow, flip, shift } from "@floating-ui/dom";

const HIDDEN_CLASS = "hidden";
const OPPOSITE_SIDES = {
  top: "bottom",
  bottom: "top",
  left: "right",
  right: "left",
};

export default class extends Controller {
  static targets = ["trigger", "content", "arrow"];

  connect() {
    if (!this.hasContentTarget) return

    this.contentTarget.insertAdjacentHTML(
      "beforeend",
      `<div data-tooltip-target="arrow" class="arrow"></div>`,
    );
    this.mobileQuery = window.matchMedia("(hover: none)");
    this.mobileQuery.addEventListener("change", this.#applyLayout);
    this.#applyLayout();
  }

  disconnect() {
    if (this.mobileQuery) this.mobileQuery.removeEventListener("change", this.#applyLayout);
    if (this.observer) this.observer.disconnect()
  }

  show() {
    if (this.mobileQuery.matches) return;

    this.contentTarget.classList.remove(HIDDEN_CLASS);
    this.#update();
  }

  hide() {
    if (this.mobileQuery.matches) return;

    this.contentTarget.classList.add(HIDDEN_CLASS);
  }

  #applyLayout = () => {
    if (this.mobileQuery.matches) {
      this.#enableMobileMode();
    } else {
      this.#enableDesktopMode();
    }
  };

  #enableMobileMode() {
    this.contentTarget.classList.remove(HIDDEN_CLASS);
    this.contentTarget.removeAttribute("style");
    this.#alignArrowToTrigger();
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.contentTarget.classList.remove(HIDDEN_CLASS)
        } else {
          this.contentTarget.classList.add(HIDDEN_CLASS)
        }
      })
    })
    this.observer.observe(this.triggerTarget)
  }

  #enableDesktopMode() {
    this.contentTarget.classList.add(HIDDEN_CLASS);
  }

  #update() {
    computePosition(this.triggerTarget, this.contentTarget, {
      placement: "top",
      middleware: [
        offset(8),
        flip(),
        shift(),
        arrow({ element: this.arrowTarget }),
      ],
    }).then(({ x, y, placement, middlewareData }) => {
      Object.assign(this.contentTarget.style, {
        left: `${x}px`,
        top: `${y}px`,
      });

      const { x: ax, y: ay } = middlewareData.arrow;
      const side = placement.split("-")[0];
      this.#assignArrowPosition(side, ax, ay);
    });
  }

  #alignArrowToTrigger() {
    const triggerRect = this.triggerTarget.getBoundingClientRect();
    const contentRect = this.contentTarget.getBoundingClientRect();
    const arrowRect = this.arrowTarget.getBoundingClientRect();

    const triggerCenter = triggerRect.left + triggerRect.width / 2;
    const arrowX = triggerCenter - contentRect.left - arrowRect.width / 2;

    this.#assignArrowPosition("bottom", arrowX, null);
  }

  #assignArrowPosition(containerSide, x, y) {
    Object.assign(this.arrowTarget.style, {
      left: x != null ? `${x}px` : "",
      top: y != null ? `${y}px` : "",
      right: "",
      bottom: "",
      [OPPOSITE_SIDES[containerSide]]: `-${this.#arrowOffset()}px`,
    });
  }

  #arrowOffset() {
    const arrowRect = this.arrowTarget.getBoundingClientRect();
    return arrowRect.height / 3;
  }
}
