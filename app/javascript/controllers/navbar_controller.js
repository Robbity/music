import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "overlay"]

  connect() {
    this.boundKeydown = (event) => {
      if (event.key === "Escape") {
        this.close()
      }
    }

    this.boundMenuClick = (event) => {
      if (event.target.closest("a, button")) {
        this.close()
      }
    }

    document.addEventListener("keydown", this.boundKeydown)
    this.menuTarget.addEventListener("click", this.boundMenuClick)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundKeydown)
    this.menuTarget.removeEventListener("click", this.boundMenuClick)
  }

  toggle(event) {
    event.preventDefault()
    const expanded = !this.menuTarget.classList.contains("is-open")
    if (expanded) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.menuTarget.classList.add("is-open")
    this.overlayTarget.classList.add("is-open")
    this.overlayTarget.setAttribute("aria-hidden", "false")
    const toggle = this.element.querySelector(".navbar__toggle")
    if (toggle) {
      toggle.setAttribute("aria-expanded", "true")
    }
  }

  close() {
    this.menuTarget.classList.remove("is-open")
    this.overlayTarget.classList.remove("is-open")
    this.overlayTarget.setAttribute("aria-hidden", "true")
    const toggle = this.element.querySelector(".navbar__toggle")
    if (toggle) {
      toggle.setAttribute("aria-expanded", "false")
    }
  }
}
