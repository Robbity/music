import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  dragOver(event) {
    event.preventDefault()
    this.previewTarget.classList.add("is-dragging")
  }

  dragLeave(event) {
    event.preventDefault()
    this.previewTarget.classList.remove("is-dragging")
  }

  drop(event) {
    event.preventDefault()
    this.previewTarget.classList.remove("is-dragging")
    if (!event.dataTransfer?.files?.length) return
    this.inputTarget.files = event.dataTransfer.files
    this.preview()
  }

  preview() {
    const file = this.inputTarget.files?.[0]
    if (!file) return

    const reader = new FileReader()
    reader.onload = (event) => {
      this.previewTarget.style.backgroundImage = `url('${event.target.result}')`
      this.previewTarget.classList.add("upload__artwork--filled")
      this.previewTarget.querySelector("span")?.remove()
    }
    reader.readAsDataURL(file)
  }
}
