import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    const expanded = this.menuTarget.classList.toggle("is-open")
    this.element.querySelector(".navbar__toggle").setAttribute("aria-expanded", expanded)
  }
}
