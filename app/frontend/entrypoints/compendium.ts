// Strip extra path segments to get the canonical path
const segments = location.pathname.replace(/^\//, "").split("/")
if (segments.length > 1) {
  history.pushState(
    null,
    "",
    `/${segments[segments.length - 1]}${location.hash}`,
  )
}

document.addEventListener("DOMContentLoaded", () => {
  // Open non-compendium links in a new tab
  document.querySelectorAll("section.page a").forEach((link) => {
    if (
      !link.getAttribute("href") ||
      !/^http/.test(link.getAttribute("href"))
    ) {
      return
    }
    link.setAttribute("target", "_blank")
  })

  // Section anchors
  const linkIcon = document.querySelector("#link-icon")
  document
    .querySelectorAll("section.page > h2, section.page > h3")
    .forEach((heading) => {
      const link = document.createElement("a")
      const icon = linkIcon.cloneNode(true)
      icon.id = null
      link.appendChild(icon)
      link.href = `#${heading.id}`
      link.classList.add("section-anchor")
      heading.appendChild(link)
    })
})
