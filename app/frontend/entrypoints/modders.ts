import Cookies from "js-cookie"

window.addEventListener("DOMContentLoaded", () => {
  const results = document.querySelector("#modder-search-results")
  if (results) results.classList.toggle("initialized")

  document.querySelectorAll(".map-toggle").forEach((toggle) => {
    toggle.addEventListener("click", () => {
      const mapInput: HTMLInputElement = document.querySelector("#map-input")
      if (mapInput) mapInput.value = mapInput.value === "1" ? "0" : "1"
      if (results) results.classList.toggle("map-visible")

      if (mapInput.value === "1")
        document.dispatchEvent(new Event("map-visible"))
    })
  })

  const serviceVisibilityToggle = document.querySelector("#services-visible")
  if (serviceVisibilityToggle) {
    serviceVisibilityToggle.addEventListener("change", () => {
      document
        .querySelector("#modder-search-results")
        .style.setProperty(
          "--service-display",
          serviceVisibilityToggle.checked ? "block" : "none"
        )
      Cookies.set("services_visible", serviceVisibilityToggle.checked ? 1 : 0)
    })
  }

  document.querySelectorAll(".discord-username").forEach((anchor) => {
    anchor.addEventListener("click", (event) => {
      const usernameElement = event.currentTarget.querySelector("span")
      const username = usernameElement.innerText
      if (username === "Copied!") return
      navigator.clipboard.writeText(username)
      usernameElement.innerText = "Copied!"
      setTimeout(() => (usernameElement.innerText = username), 3000)
    })
  })
})
