import "./PhotoManager.scss"

import React, { useState, ChangeEvent } from "react"
import classNames from "classnames"
import {
  DndContext,
  DragEndEvent,
  PointerSensor,
  useSensor,
  useSensors,
} from "@dnd-kit/core"
import {
  horizontalListSortingStrategy,
  SortableContext,
  arrayMove,
} from "@dnd-kit/sortable"

import SortablePhoto from "./PhotoManager/SortablePhoto"
import UploadIcon from "@/icons/upload.svg"
import Spinner from "@/icons/spinner.svg"
import GccIcon from "@/icons/gcc.svg"

interface Photo {
  uuid: string
  url: string
  width: number
  height: number
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

class SmartPointerSensor extends PointerSensor {
  static activators = [
    {
      eventName: "onMouseDown" as const,
      handler: ({ nativeEvent: event }: MouseEvent) => {
        let cur = event.target

        while (cur) {
          if (cur.dataset && cur.dataset.noDnd) {
            return false
          }
          cur = cur.parentElement
        }

        return true
      },
    },
  ]
}

export default (props: PhotoManagerProps) => {
  const [open, setOpen] = useState<boolean>(false)
  const [uploading, setUploading] = useState<boolean>(false)
  const [droppable, setDroppable] = useState<boolean>(false)
  const [error, setError] = useState<string>("")
  const [photos, setPhotos] = useState<Photo[]>(props.photos || [])

  const sensors = useSensors(useSensor(SmartPointerSensor))

  function getMessage() {
    if (photos.length < 2)
      return "Click the upload icon or drop a file on it to add photos."
    else return "Drag and drop to reorder photos."
  }

  function handleManagePhotosClick() {
    setOpen(true)
  }

  function handleDoneClick() {
    setOpen(false)

    fetch("/profile/photo-order", {
      method: "POST",
      headers: {
        "X-CSRF-Token": props.csrfToken,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        photos: photos.map((photo) => photo.uuid),
      }),
    })
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

    if (file.size > 1024 * 10000) {
      setError("Photo must be less than 10MB.")
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

  function handleDragEnd(event: DragEndEvent) {
    const { active, over } = event

    if (!active || !over) return
    if (active.id === over.id) return

    setPhotos((photos) => {
      const oldIndex = photos.findIndex((photo) => photo.uuid === active.id)
      const newIndex = photos.findIndex((photo) => photo.uuid === over.id)

      return arrayMove(photos, oldIndex, newIndex)
    })
  }

  function handleRemovePhoto(uuid: string) {
    setPhotos((photos) => {
      const index = photos.findIndex((photo) => photo.uuid === uuid)
      const modifiedPhotos = photos.slice()
      modifiedPhotos.splice(index, 1)
      return modifiedPhotos
    })

    fetch(`/profile/remove-photo/${uuid}`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": props.csrfToken,
        "Content-Type": "application/json",
      },
    })
  }

  return (
    <DndContext onDragEnd={handleDragEnd} sensors={sensors}>
      <div className={classNames("PhotoManager", { open, uploading })}>
        {(() => {
          if (open)
            return (
              <>
                <div className="overlay"></div>
                <div className="manager">
                  <SortableContext
                    items={photos.map((photo) => photo.uuid)}
                    strategy={horizontalListSortingStrategy}
                  >
                    {photos.map((photo) => (
                      <SortablePhoto
                        key={photo.uuid}
                        src={photo.url}
                        width={photo.width}
                        height={photo.height}
                        uuid={photo.uuid}
                        onRemoveClick={handleRemovePhoto}
                      />
                    ))}
                  </SortableContext>
                  {photos.length < 10 && (
                    <div
                      className={classNames("uploader", {
                        uploading,
                        droppable,
                      })}
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
                    onClick={handleDoneClick}
                  >
                    Done
                  </button>

                  {(error && <p className="error">{error}</p>) || (
                    <p>{getMessage()}</p>
                  )}
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
                  {photos.length === 0 && (
                    <>
                      <figure>
                        <GccIcon />
                      </figure>
                      <figure>
                        <GccIcon />
                      </figure>
                      <figure>
                        <GccIcon />
                      </figure>
                      <figure>
                        <GccIcon />
                      </figure>
                      <figure>
                        <GccIcon />
                      </figure>
                      <figure>
                        <GccIcon />
                      </figure>
                    </>
                  )}
                </div>
                <div className="toggle-container">
                  <figure className="frame">
                    <button
                      type="button"
                      className="button secondary"
                      onClick={handleManagePhotosClick}
                    >
                      Manage photos
                    </button>
                  </figure>
                </div>
              </>
            )
        })()}
      </div>
    </DndContext>
  )
}
