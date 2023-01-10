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

        if (props.onLocation) props.onLocation(latitude, longitude)
        else {
          setLatitude(latitude)
          setLongitude(longitude)
        }

        if (props.autosubmit)
          setTimeout(() => latitudeInput.current.form.submit(), 10)
      }
    )
  }

  return (
    <div className="Geolocator">
      <button type="button" onClick={handleButtonClick} className="link">
        <ArrowIcon />
        Use my location
      </button>
      {!props.onLocation && (
        <>
          <input
            type="hidden"
            name="latitude"
            value={latitude}
            ref={latitudeInput}
          />
          <input type="hidden" name="longitude" value={longitude} />
        </>
      )}
    </div>
  )
}
