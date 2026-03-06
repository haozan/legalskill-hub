import { Controller } from "@hotwired/stimulus"

// Polls /wechat/pay/status/:out_trade_no every 2s until paid, then redirects.
// Targets:
//   statusTarget  - element showing current status text
//   spinnerTarget - loading spinner shown while polling
// Values:
//   outTradeNo  - the order's out_trade_no
//   successUrl  - redirect URL on successful payment
//   statusUrl   - base URL for status polling

export default class extends Controller<HTMLElement> {
  static targets = ["status", "spinner"]
  static values  = {
    outTradeNo: String,
    successUrl: String,
    statusUrl:  String
  }

  declare readonly statusTarget:  HTMLElement
  declare readonly spinnerTarget: HTMLElement
  declare readonly outTradeNoValue: string
  declare readonly successUrlValue: string
  declare readonly statusUrlValue:  string

  private timer: ReturnType<typeof setInterval> | null = null

  connect(): void {
    this.startPolling()
  }

  disconnect(): void {
    this.stopPolling()
  }

  private startPolling(): void {
    this.timer = setInterval(() => this.checkStatus(), 2000)
  }

  private stopPolling(): void {
    if (this.timer) {
      clearInterval(this.timer)
      this.timer = null
    }
  }

  private async checkStatus(): Promise<void> {
    try {
      const url      = `${this.statusUrlValue}/${this.outTradeNoValue}`
      const response = await fetch(url, {
        headers: { "Accept": "application/json", "X-Requested-With": "XMLHttpRequest" }
      })
      const data = await response.json()

      if (data.status === "paid") {
        this.stopPolling()
        this.statusTarget.textContent = "支付成功，正在跳转..."
        window.location.href = this.successUrlValue
      } else if (data.status === "failed" || data.status === "closed") {
        this.stopPolling()
        this.statusTarget.textContent = "支付失败或已关闭，请重新发起"
      }
    } catch {
      // Network error - keep polling
    }
  }
}
