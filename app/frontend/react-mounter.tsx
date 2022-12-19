import React from "react"
import { createRoot } from "react-dom/client"

const components = import.meta.glob("./components/*", { eager: true })

window.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".react-container").forEach(container => {
    const Component = components[`./components/${container.dataset.component}.tsx`].default
    const root = createRoot(container)
    root.render(<Component {...JSON.parse(container.dataset.props)} />)
  })
})
