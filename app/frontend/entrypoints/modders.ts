window.addEventListener("DOMContentLoaded", () => {
  document.querySelector("#map-toggle").addEventListener("click", () => {
    const mapInput: HTMLInputElement = document.querySelector("#map-input")
    if (mapInput) mapInput.value = mapInput.value === "1" ? "0" : "1"

    const results = document.querySelector("#modder-search-results")
    if (results) results.classList.toggle("map-visible")
  })
})
