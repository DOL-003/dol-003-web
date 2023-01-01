import "./LogoSelector.scss"

import React, { useState, ChangeEvent } from "react"

import GccIcon from "@/icons/gcc.svg"
import UploadIcon from "@/icons/upload.svg"

const validFileTypes = ["image/png", "image/jpg", "image/jpeg", "image/gif"]

interface LogoSelectorProps {
  readonly fieldName: string
  readonly logoUrl: string
}

export default (props: LogoSelectorProps) => {
  const [logoUrl, setLogoUrl] = useState(props.logoUrl)
  const [error, setError] = useState("")

  function handleLogoChange(event: ChangeEvent<HTMLInputElement>) {
    setError("")

    const file = event.target.files[0]
    if (!file) return

    if (file.size > 1024 * 1000) {
      setError("Logo must be less than 1MB.")
      return
    }

    if (!validFileTypes.includes(file.type)) {
      setError("Invalid file type. Please upload a PNG, JPG or GIF.")
      return
    }

    setLogoUrl(URL.createObjectURL(file))
  }

  const figureStyle = logoUrl ? { backgroundImage: `url(${logoUrl})` } : {}

  return (
    <div className="LogoSelector">
      <figure style={figureStyle}>
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

      <p className="error">{error}</p>
    </div>
  )
}
