import "./Geolocator.scss"

import React, { useState, useRef } from "react"

import ArrowIcon from "@/icons/nav-arrow.svg"

interface GeolocatorProps {
  readonly autosubmit?: boolean
  readonly onLocation?: (latitude: string, longitude: string) => void
  readonly onClick?: Function
}

export default (props: GeolocatorProps) => {
  const [latitude, setLatitude] = useState("")
  const [longitude, setLongitude] = useState("")

  const latitudeInput = useRef<HTMLInputElement>()

  function handleButtonClick() {
    if (props.onClick) props.onClick()

    navigator.geolocation.getCurrentPosition(
      (position: GeolocationPosition) => {
        const latitude = position.coords.latitude.toString()
        const longitude = position.coords.longitude.toString()

        setLatitude(latitude)
        setLongitude(longitude)

        if (props.onLocation) props.onLocation(latitude, longitude)

        if (props.autosubmit)
          setTimeout(() => latitudeInput.current.form.submit(), 10)
      }
    )
  }

  return (
    <div className="Geolocator">
      <button type="button" onClick={handleButtonClick} className="link">
        <ArrowIcon />
        <span>Use my location</span>
      </button>
      <input
        type="hidden"
        name="latitude"
        value={latitude}
        ref={latitudeInput}
      />
      <input type="hidden" name="longitude" value={longitude} />
    </div>
  )
}
