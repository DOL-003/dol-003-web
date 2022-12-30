import React from "react"
import { useSortable } from "@dnd-kit/sortable"
import { CSS } from "@dnd-kit/utilities"

import XIcon from "@/icons/x.svg"

interface SortablePhotoProps {
  readonly src: string
  readonly uuid: string
  readonly onRemoveClick: (uuid: string) => void
}

export default (props: SortablePhotoProps) => {
  const { attributes, listeners, setNodeRef, transform, transition } =
    useSortable({ id: props.uuid })

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  }

  function handleRemoveClick() {
    props.onRemoveClick(props.uuid)
  }

  return (
    <div
      className="SortablePhoto"
      ref={setNodeRef}
      style={style}
      {...attributes}
      {...listeners}
    >
      <img src={props.src} />
      <button data-no-dnd="true" type="button" onClick={handleRemoveClick}>
        <XIcon />
      </button>
    </div>
  )
}
