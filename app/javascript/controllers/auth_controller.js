import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["signIn", "signUp"]

  showSignIn() {
    this.signInTarget.classList.remove("hidden")
    this.signUpTarget.classList.add("hidden")
  }

  showSignUp() {
    this.signUpTarget.classList.remove("hidden")
    this.signInTarget.classList.add("hidden")
  }
}
