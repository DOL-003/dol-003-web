import "./Geolocator.scss"

import React, { useState, useRef } from "react"

import ArrowIcon from "@/icons/nav-arrow.svg"

export default () => {
  const [latitude, setLatitude] = useState("")
  const [longitude, setLongitude] = useState("")

  const latitudeInput = useRef<HTMLInputElement>()

  function handleButtonClick() {
    navigator.geolocation.getCurrentPosition(
      (position: GeolocationPosition) => {
        setLatitude(position.coords.latitude.toString())
        setLongitude(position.coords.longitude.toString())
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
