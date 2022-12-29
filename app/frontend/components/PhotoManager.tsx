import "./PhotoManager.scss"

import React, { useState } from "react"
import classNames from "classnames"

interface Photo {
  uuid?: string
  url: string
  uploading?: boolean
}

export default (props) => {
  const [open, setOpen] = useState(false)
  const [photos, setPhotos] = useState<Photo[]>([])

  function handleOpenToggleClick() {
    setOpen(!open)
  }

  return (
    <div className={classNames("PhotoManager", { open })}>
      {(() => {
        if (open)
          return (
            <>
              <div className="overlay"></div>
              <div className="manager">
                {photos.map((photo) => (
                  <div>here's a photo</div>
                ))}
              </div>
              <div className="controls">
                <button
                  type="button"
                  className="button"
                  onClick={handleOpenToggleClick}
                >
                  Done
                </button>
              </div>
            </>
          )
        else
          return (
            <button
              type="button"
              className="button secondary"
              onClick={handleOpenToggleClick}
            >
              Manage photos
            </button>
          )
      })()}
    </div>
  )
}
