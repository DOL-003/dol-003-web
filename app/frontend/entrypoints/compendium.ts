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
    link.innerHTML += `<svg viewBox="0 0 24 24"><path d="M21 13v10h-21v-19h12v2h-10v15h17v-8h2zm3-12h-10.988l4.035 4-6.977 7.07 2.828 2.828 6.977-7.07 4.125 4.172v-11z" fill="currentColor"/></svg>`
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
