import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    const expanded = this.menuTarget.classList.toggle("is-open")
    const toggle = this.element.querySelector(".navbar__toggle")
    if (toggle) {
      toggle.setAttribute("aria-expanded", expanded)
    }
  }
}
