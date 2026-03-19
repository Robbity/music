import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rating", "stars", "submit", "play"]
  static values = {
    url: String,
    title: String,
    artist: String,
    artwork: String
  }

  connect() {
    this.canRate = false
    this.loaded = false
    if (this.hasRatingTarget) {
      this.disableRating()
    }
    if (this.hasPlayTarget) {
      this.playTarget.textContent = "Play"
    }

    window.addEventListener("player:ended", this.handleEnded)
    window.addEventListener("player:state", this.handleState)
  }

  disconnect() {
    window.removeEventListener("player:ended", this.handleEnded)
    window.removeEventListener("player:state", this.handleState)
  }

  handleEnded = () => {
    this.enableRating()
  }

  handleState = (event) => {
    if (!this.hasPlayTarget) return
    this.playTarget.textContent = event.detail.playing ? "Pause" : "Play"
  }

  togglePlayback() {
    if (!this.loaded) {
      this.loadPlayer()
      this.loaded = true
      return
    }

    window.dispatchEvent(new CustomEvent("player:toggle"))
  }

  enableRating() {
    this.canRate = true
    this.ratingTarget.classList.remove("hidden")
  }

  showRating() {
    if (!this.canRate) return
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

  loadPlayer() {
    window.dispatchEvent(
      new CustomEvent("player:load", {
        detail: {
          url: this.urlValue,
          title: this.titleValue,
          artist: this.artistValue,
          artwork: this.artworkValue,
          locked: true
        }
      })
    )
  }
}
