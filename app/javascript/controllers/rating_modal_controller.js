import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "stars"]

  connect() {
    this.boundKeydown = (event) => {
      if (event.key === "Escape") {
        this.close()
      }
    }
    document.addEventListener("keydown", this.boundKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this.boundKeydown)
  }

  open(event) {
    const ratingId = event.currentTarget.dataset.ratingId
    const ratingStars = event.currentTarget.dataset.ratingStars
    this.formTarget.action = `/ratings/${ratingId}`

    const inputs = this.starsTarget.querySelectorAll("input")
    inputs.forEach((input) => {
      input.checked = input.value === ratingStars
    })

    this.element.classList.remove("hidden")
    this.element.setAttribute("aria-hidden", "false")
  }

  close() {
    this.element.classList.add("hidden")
    this.element.setAttribute("aria-hidden", "true")
  }
}
