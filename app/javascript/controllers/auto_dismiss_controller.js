import { Controller } from "@hotwired/stimulus"

// Automatically dismisses flash messages after a delay
// Usage: data-controller="auto-dismiss" data-auto-dismiss-delay-value="3000"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 3000 }
  }

  connect() {
    this.timeout = setTimeout(() => {
      this.dismiss()
    }, this.delayValue)
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  dismiss() {
    this.element.classList.add("opacity-0", "transition-opacity", "duration-300")
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
