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
})
