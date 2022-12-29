import "./PhotoManager.scss"

import React, { useState } from "react"
import classNames from "classnames"

export default (props) => {
  const [open, setOpen] = useState(false)

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
              <div className="manager">i'm managing dude</div>
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
