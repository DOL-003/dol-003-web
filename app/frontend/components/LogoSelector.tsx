import "./LogoSelector.scss"

import React, { useState } from "react"

interface LogoSelectorProps {
  readonly fieldName: string
  readonly logoUrl: string
}

export default (props: LogoSelectorProps) => {
  const [logoUrl, setLogoUrl] = useState(props.logoUrl)

  function handleLogoChange(event) {
    const [file] = event.target.files
    if (file) {
      setLogoUrl(URL.createObjectURL(file))
    }
  }

  return (
    <div className="LogoSelector">
      <figure style={{ backgroundImage: `url(${logoUrl})` }} />
      <input type="file" name={props.fieldName} onChange={handleLogoChange} />
    </div>
  )
}
