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
import GccIcon from "@/icons/gcc.svg"
import UploadIcon from "@/icons/upload.svg"

export interface Photo {
  uuid: string
  url?: string
  width?: number
  height?: number
  uploading?: boolean
}

interface PhotoResult {
  success: boolean
  photo?: Photo
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
    setError("")

    const files = event.target.files
    if (!files || !files.length) return

    // Validate all files first.
    for (let i = 0; i < files.length; i++) {
      if (files[i].size > 1024 * 25000) {
        setError("Photos must be less than 25MB each.")
        return
      }

      if (!validFileTypes.includes(files[i].type)) {
        setError("Only PNG, JPG and GIF files allowed.")
        return
      }
    }

    // Now upload each one.
    for (let i = 0; i < files.length; i++) {
      if (photos.length + 1 + i > 10) {
        setError("Maximum of 10 photos can be uploaded.")
        return
      }

      uploadPhoto(files[i])
    }
  }

  async function uploadPhoto(file: File) {
    const tempUuid = `uploading-photo-${(Math.random() + 1)
      .toString(36)
      .substring(7)}`

    setPhotos((photos) => [...photos, { uuid: tempUuid, uploading: true }])

    const body = new FormData()
    body.append("photo", file)
    body.append("authenticity_token", props.csrfToken)

    let result: PhotoResult = { success: false }
    try {
      const response = await fetch("/profile/photo", {
        method: "POST",
        body,
      })

      result = await response.json()
    } catch (e) { }

    if (result.success) {
      setPhotos((photos) => {
        const index = photos.findIndex((photo) => photo.uuid === tempUuid)
        return photos
          .slice(0, index)
          .concat([result.photo])
          .concat(photos.slice(index + 1))
      })
    } else {
      setPhotos((photos) => {
        const index = photos.findIndex((photo) => photo.uuid === tempUuid)
        return photos.slice(0, index).concat(photos.slice(index + 1))
      })
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
      <div
        className={classNames("PhotoManager", {
          open,
        })}
      >
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
                        photo={photo}
                        onRemoveClick={handleRemovePhoto}
                      />
                    ))}
                  </SortableContext>
                  {photos.length < 10 && (
                    <div
                      className={classNames("uploader", {
                        droppable,
                      })}
                    >
                      <UploadIcon />
                      <input
                        type="file"
                        multiple={true}
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
                    <img
                      key={photo.uuid}
                      src={photo.url}
                      width={photo.width}
                      height={photo.height}
                    />
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
