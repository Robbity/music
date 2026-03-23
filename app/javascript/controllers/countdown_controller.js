import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]
  static values = { until: String }

  connect() {
    this.tick = this.tick.bind(this)
    this.tick()
    this.interval = setInterval(this.tick, 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  tick() {
    if (!this.hasUntilValue) return
    const target = new Date(this.untilValue)
    const now = new Date()
    const diff = Math.max(0, target - now)
    const hours = Math.floor(diff / 3_600_000)
    const minutes = Math.floor((diff % 3_600_000) / 60_000)
    const seconds = Math.floor((diff % 60_000) / 1000)
    this.outputTarget.textContent = `${this.format(hours)}:${this.format(minutes)}:${this.format(seconds)}`
  }

  format(value) {
    return String(value).padStart(2, "0")
  }
}
