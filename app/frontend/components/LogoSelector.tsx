import "./LogoSelector.scss"

import React, { useState } from "react"

import GccIcon from "@/icons/gcc.svg"
import UploadIcon from "@/icons/upload.svg"

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
      <figure style={{ backgroundImage: `url(${logoUrl})` }}>
        {!logoUrl && <GccIcon />}
        <div className="upload-overlay">
          <UploadIcon />
        </div>
        <input
          type="file"
          name={props.fieldName}
          onChange={handleLogoChange}
          title="Drop an image here to upload it, or click to choose one."
        />
      </figure>
    </div>
  )
}
