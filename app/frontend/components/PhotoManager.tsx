import "./PhotoManager.scss"

import React, { useState, ChangeEvent } from "react"
import classNames from "classnames"

import UploadIcon from "@/icons/upload.svg"
import Spinner from "@/icons/spinner.svg"

interface Photo {
  uuid: string
  url: string
}

interface PhotoResult {
  success: boolean
  photo: Photo
}

interface PhotoManagerProps {
  photos: Photo[]
  csrfToken: string
}

const validFileTypes = ["image/png", "image/jpg", "image/jpeg", "image/gif"]

export default (props: PhotoManagerProps) => {
  const [open, setOpen] = useState<boolean>(false)
  const [uploading, setUploading] = useState<boolean>(false)
  const [droppable, setDroppable] = useState<boolean>(false)
  const [error, setError] = useState<string>("")
  const [photos, setPhotos] = useState<Photo[]>(props.photos || [])

  function handleOpenToggleClick() {
    setOpen(!open)
  }

  function handleInputDragEnter() {
    setDroppable(true)
  }

  function handleInputDragLeave() {
    setDroppable(false)
  }

  async function handlePhotoSelected(event: ChangeEvent<HTMLInputElement>) {
    if (uploading) return

    setError("")

    const file = event.target.files[0]
    if (!file) return

    if (file.size > 1024 * 5000) {
      setError("Photo must be less than 5MB.")
      return
    }

    if (!validFileTypes.includes(file.type)) {
      setError("Invalid file type. Please upload a PNG, JPG or GIF.")
      return
    }

    setUploading(true)

    const body = new FormData()
    body.append("photo", file)
    body.append("authenticity_token", props.csrfToken)

    const response = await fetch("/profile/photo", {
      method: "POST",
      body,
    })

    setUploading(false)

    const result: PhotoResult = await response.json()
    if (result.success) {
      setPhotos([...photos, result.photo])
    } else {
      setError("Your photo could not be uploaded.")
    }
  }

  return (
    <div className={classNames("PhotoManager", { open, uploading })}>
      {(() => {
        if (open)
          return (
            <>
              <div className="overlay"></div>
              <div className="manager">
                {photos.map((photo) => (
                  <img key={photo.uuid} src={photo.url} />
                ))}
                {photos.length < 10 && (
                  <div
                    className={classNames("uploader", { uploading, droppable })}
                  >
                    {uploading ? <Spinner /> : <UploadIcon />}
                    <input
                      type="file"
                      onChange={handlePhotoSelected}
                      title="Drop an image here to upload it, or click to choose one."
                      onDragEnter={handleInputDragEnter}
                      onDragLeave={handleInputDragLeave}
                      onDrop={handleInputDragLeave}
                    />
                  </div>
                )}
              </div>
              <div className="controls">
                <button
                  type="button"
                  className="button"
                  onClick={handleOpenToggleClick}
                >
                  Done
                </button>

                {error && <p className="error">{error}</p>}
              </div>
            </>
          )
        else
          return (
            <>
              <div className="gallery">
                {photos.map((photo) => (
                  <img key={photo.uuid} src={photo.url} />
                ))}
              </div>
              <div className="toggle-container">
                <button
                  type="button"
                  className="button secondary"
                  onClick={handleOpenToggleClick}
                >
                  Manage photos
                </button>
              </div>
            </>
          )
      })()}
    </div>
  )
}
