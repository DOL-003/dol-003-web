import React from "react"
import { useSortable } from "@dnd-kit/sortable"
import { CSS } from "@dnd-kit/utilities"

interface SortablePhotoProps {
  readonly src: string
  readonly uuid: string
}

export default (props: SortablePhotoProps) => {
  const { attributes, listeners, setNodeRef, transform, transition } =
    useSortable({ id: props.uuid })

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
  }

  return (
    <img
      src={props.src}
      ref={setNodeRef}
      style={style}
      {...attributes}
      {...listeners}
    />
  )
}
