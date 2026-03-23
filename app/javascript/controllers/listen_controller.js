import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rating", "stars", "submit", "play", "timer", "artwork"]
  static values = {
    url: String,
    title: String,
    artist: String,
    artwork: String,
    id: String
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
    if (this.hasTimerTarget) {
      this.timerTarget.textContent = "0:00 / 0:00"
    }

    if (this.urlValue) {
      window.dispatchEvent(
        new CustomEvent("player:load", {
          detail: {
            url: this.urlValue,
            title: this.titleValue,
            artist: this.artistValue,
            artwork: this.artworkValue,
            locked: true,
            autoplay: false,
            prefetch: true,
            id: this.hasIdValue ? this.idValue : undefined
          }
        })
      )
    }

    window.addEventListener("player:ended", this.handleEnded)
    window.addEventListener("player:state", this.handleState)
    window.addEventListener("player:progress", this.handleProgress)
  }

  disconnect() {
    window.removeEventListener("player:ended", this.handleEnded)
    window.removeEventListener("player:state", this.handleState)
    window.removeEventListener("player:progress", this.handleProgress)
  }

  handleEnded = () => {
    this.enableRating()
  }

  handleState = (event) => {
    if (!this.hasPlayTarget) return
    this.playTarget.textContent = event.detail.playing ? "Pause" : "Play"
    if (this.hasArtworkTarget) {
      this.artworkTarget.dataset.playing = event.detail.playing ? "true" : "false"
    }
  }

  handleProgress = (event) => {
    if (!this.hasTimerTarget) return
    const { currentTime, duration } = event.detail
    if (!duration) return
    this.timerTarget.textContent = `${this.formatTime(currentTime)} / ${this.formatTime(duration)}`
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
    this.enableInputs()
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
    const detail = {
      url: this.urlValue,
      title: this.titleValue,
      artist: this.artistValue,
      artwork: this.artworkValue,
      locked: true
    }

    if (this.hasIdValue) {
      detail.id = this.idValue
    }

    window.dispatchEvent(
      new CustomEvent("player:load", {
        detail: {
          ...detail
        }
      })
    )
  }

  formatTime(seconds) {
    const clampedSeconds = Number.isFinite(seconds) ? Math.floor(seconds) : 0
    const minutes = Math.floor(clampedSeconds / 60)
    const remainder = clampedSeconds % 60
    return `${minutes}:${String(remainder).padStart(2, "0")}`
  }
}
