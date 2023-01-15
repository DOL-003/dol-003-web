import React from "react"
import { useSortable } from "@dnd-kit/sortable"
import { CSS } from "@dnd-kit/utilities"
import classNames from "classnames"

import type { Photo } from "../PhotoManager"

import XIcon from "@/icons/x.svg"
import Spinner from "@/icons/spinner.svg"

interface SortablePhotoProps {
  readonly photo: Photo
  readonly onRemoveClick: (uuid: string) => void
}

export default (props: SortablePhotoProps) => {
  const { attributes, listeners, setNodeRef, transform, transition } =
    useSortable({ id: props.photo.uuid })

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  }

  function handleRemoveClick() {
    props.onRemoveClick(props.photo.uuid)
  }

  return (
    <div
      className={classNames("SortablePhoto", {
        uploading: props.photo.uploading,
      })}
      ref={setNodeRef}
      style={style}
      {...attributes}
      {...listeners}
    >
      {(() => {
        if (props.photo.uploading) return <Spinner className="spinner" />
        else
          return (
            <>
              <img
                src={props.photo.url}
                width={props.photo.width}
                height={props.photo.height}
              />
              <button
                data-no-dnd="true"
                type="button"
                onClick={handleRemoveClick}
              >
                <XIcon />
              </button>
            </>
          )
      })()}
    </div>
  )
}
