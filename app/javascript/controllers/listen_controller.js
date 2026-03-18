import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "rating", "stars", "submit"]

  connect() {
    if (this.hasRatingTarget) {
      this.disableRating()
    }
  }

  enableRating() {
    this.ratingTarget.classList.remove("hidden")
    this.enableInputs()
  }

  disableRating() {
    this.ratingTarget.classList.add("hidden")
    this.disableInputs()
  }

  enableInputs() {
    this.starsTarget.querySelectorAll("input").forEach((input) => {
      input.disabled = false
    })
    this.submitTarget.disabled = false
  }

  disableInputs() {
    this.starsTarget.querySelectorAll("input").forEach((input) => {
      input.disabled = true
    })
    this.submitTarget.disabled = true
  }
}
