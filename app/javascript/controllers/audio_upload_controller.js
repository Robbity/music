import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "name", "drop"]

  dragOver(event) {
    event.preventDefault()
    this.dropTarget.classList.add("is-dragging")
  }

  dragLeave(event) {
    event.preventDefault()
    this.dropTarget.classList.remove("is-dragging")
  }

  drop(event) {
    event.preventDefault()
    this.dropTarget.classList.remove("is-dragging")
    if (!event.dataTransfer?.files?.length) return
    this.inputTarget.files = event.dataTransfer.files
    this.update()
  }

  update() {
    const file = this.inputTarget.files?.[0]
    if (!file) return
    this.nameTarget.textContent = file.name
    this.dropTarget.classList.add("upload__drop--filled")
  }
}
