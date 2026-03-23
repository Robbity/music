// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const setupConfirmModal = () => {
  const modal = document.getElementById("confirm-modal")
  if (!modal || modal.dataset.confirmBound === "true") return

  modal.dataset.confirmBound = "true"
  const title = modal.querySelector("[data-modal-title]")
  const message = modal.querySelector("[data-modal-message]")
  const confirmButton = modal.querySelector("[data-modal-confirm]")
  const cancelButton = modal.querySelector("[data-modal-cancel]")
  const overlay = modal.querySelector("[data-modal-overlay]")

  let resolver = null
  let lastActiveElement = null

  const close = (value) => {
    modal.classList.add("hidden")
    modal.setAttribute("aria-hidden", "true")
    if (lastActiveElement) {
      lastActiveElement.focus()
      lastActiveElement = null
    }
    if (resolver) {
      resolver(value)
      resolver = null
    }
  }

  const open = (messageText, element) => {
    lastActiveElement = document.activeElement
    title.textContent = element?.dataset?.confirmTitle || "Confirm"
    message.textContent = messageText
    modal.classList.remove("hidden")
    modal.setAttribute("aria-hidden", "false")
    confirmButton.focus()
  }

  confirmButton.addEventListener("click", () => close(true))
  cancelButton.addEventListener("click", () => close(false))
  overlay.addEventListener("click", () => close(false))
  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape" && !modal.classList.contains("hidden")) {
      event.preventDefault()
      close(false)
    }
  })

  window.Turbo.config.forms.confirm = (messageText, element) => {
    open(messageText, element)
    return new Promise((resolve) => {
      resolver = resolve
    })
  }
}

document.addEventListener("turbo:load", setupConfirmModal)
