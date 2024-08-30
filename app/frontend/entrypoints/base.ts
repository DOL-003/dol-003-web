import "../react-mounter"

window.addEventListener("DOMContentLoaded", () => {
  const toggle = document.querySelector("#user-menu-toggle")
  if (toggle) {
    document.addEventListener("click", (event) => {
      if (toggle.checked && !event.target.closest(".user-menu")) {
        toggle.checked = false
      }
    })
  }
})
