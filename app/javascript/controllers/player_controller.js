import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "title", "artist", "artwork", "toggle", "scrub", "volume", "container"]
  static values = {
    volume: { type: Number, default: 1 }
  }

  connect() {
    if (!this.hasContainerTarget) return

    this.containerTarget.classList.add("hidden")
    this.currentUrl = null
    if (this.hasVolumeTarget) {
      const storedVolume = window.localStorage.getItem("player:volume")
      if (storedVolume !== null) {
        const parsedVolume = parseFloat(storedVolume)
        if (!Number.isNaN(parsedVolume)) {
          this.volumeTarget.value = parsedVolume
        }
      }
      this.audioTarget.volume = parseFloat(this.volumeTarget.value)
    }
    this.audioTarget.addEventListener("timeupdate", () => this.updateScrub())
    this.audioTarget.addEventListener("loadedmetadata", () => this.syncScrubRange())
    this.audioTarget.addEventListener("ended", () => {
      this.updateToggleLabel()
      this.containerTarget.classList.add("hidden")
      this.updateOverlayState(false)
      window.dispatchEvent(new CustomEvent("player:ended"))
      window.dispatchEvent(new CustomEvent("player:state", { detail: { playing: false } }))
    })

    this.handleLoad = (event) => this.load(event.detail)
    this.handleToggle = () => this.toggle()
    this.handleVolume = (event) => this.setVolume(event)

    window.addEventListener("player:load", this.handleLoad)
    window.addEventListener("player:toggle", this.handleToggle)
    window.addEventListener("player:volume", this.handleVolume)
  }

  disconnect() {
    window.removeEventListener("player:load", this.handleLoad)
    window.removeEventListener("player:toggle", this.handleToggle)
    window.removeEventListener("player:volume", this.handleVolume)
  }

  playFromCard(event) {
    const card = event.currentTarget
    const url = card.dataset.playerUrl
    if (!url) return

    if (this.currentUrl === url) {
      this.toggle()
      return
    }

    this.load({
      url,
      title: card.dataset.playerTitle,
      artist: card.dataset.playerArtist,
      artwork: card.dataset.playerArtwork,
      locked: card.dataset.playerLocked === "true",
      autoplay: true
    })
  }

  load({ url, title, artist, artwork, locked, autoplay, id }) {
    if (!url) return

    this.audioTarget.src = url
    this.currentUrl = url
    this.trackPlay(id)
    if (this.hasTitleTarget) {
      this.titleTarget.textContent = title || "Untitled"
    }
    if (this.hasArtistTarget) {
      this.artistTarget.textContent = artist || ""
    }

    if (this.hasArtworkTarget) {
      if (artwork) {
        this.artworkTarget.style.backgroundImage = `url('${artwork}')`
        this.artworkTarget.textContent = ""
      } else {
        this.artworkTarget.style.backgroundImage = "none"
        this.artworkTarget.textContent = "TS"
      }
    }

    this.containerTarget.classList.remove("hidden")
    this.containerTarget.classList.toggle("player--locked", locked)

    if (this.hasScrubTarget) {
      if (locked) {
        this.scrubTarget.value = 0
        this.scrubTarget.disabled = true
      } else {
        this.scrubTarget.disabled = false
      }
    }

    if (autoplay || autoplay === undefined) {
      this.audioTarget.play()
    }

    this.updateToggleLabel()
    this.updateOverlayState(!this.audioTarget.paused)
    window.dispatchEvent(new CustomEvent("player:state", { detail: { playing: !this.audioTarget.paused } }))
  }

  toggle() {
    if (this.audioTarget.paused) {
      this.audioTarget.play()
      this.containerTarget.classList.remove("hidden")
    } else {
      this.audioTarget.pause()
      this.containerTarget.classList.add("hidden")
    }
    this.updateToggleLabel()
    this.updateOverlayState(!this.audioTarget.paused)
    window.dispatchEvent(new CustomEvent("player:state", { detail: { playing: !this.audioTarget.paused } }))
  }

  seek(event) {
    if (!this.audioTarget.duration) return
    const value = parseFloat(event.target.value)
    this.audioTarget.currentTime = (value / 100) * this.audioTarget.duration
  }

  setVolume(event) {
    const value = event?.detail?.value ?? event.target.value
    const parsedValue = parseFloat(value)
    this.audioTarget.volume = parsedValue
    window.localStorage.setItem("player:volume", parsedValue)
  }

  trackPlay(id) {
    if (!id) return
    const token = document.querySelector("meta[name='csrf-token']")?.content
    fetch(`/songs/${id}/play`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": token,
        Accept: "application/json"
      },
      credentials: "same-origin"
    })
  }

  syncScrubRange() {
    if (!this.hasScrubTarget) return
    this.scrubTarget.value = 0
  }

  updateScrub() {
    if (!this.hasScrubTarget) return
    if (!this.audioTarget.duration) return
    const progress = (this.audioTarget.currentTime / this.audioTarget.duration) * 100
    this.scrubTarget.value = progress
  }

  updateToggleLabel() {
    if (!this.hasToggleTarget) return
    this.toggleTarget.textContent = this.audioTarget.paused ? "Play" : "Pause"
  }

  updateOverlayState(isPlaying) {
    const buttons = document.querySelectorAll("[data-player-url]")
    buttons.forEach((button) => {
      if (button.dataset.playerUrl === this.currentUrl) {
        button.dataset.playing = isPlaying ? "true" : "false"
      } else {
        button.dataset.playing = "false"
      }
    })
  }
}
