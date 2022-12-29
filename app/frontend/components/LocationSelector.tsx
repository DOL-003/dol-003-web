import "./LocationSelector.scss"

import React, { useState, useRef } from "react"
import Autocomplete from "react-google-autocomplete"

interface LocationSelectorProps {
  readonly modelName?: string
  readonly city?: string
  readonly latitude?: string
  readonly longitude?: string
  readonly class?: string
  readonly placeholder?: string
  readonly autosubmit?: boolean
}

interface PlaceResult {
  formatted_address: string
  geometry: {
    location: {
      lat: () => number
      lng: () => number
    }
  }
}

export default (props: LocationSelectorProps) => {
  const [city, setCity] = useState(props.city || "")
  const [latitude, setLatitude] = useState(props.latitude || "")
  const [longitude, setLongitude] = useState(props.longitude || "")
  const input = useRef<HTMLInputElement>()

  const handlePlaceSelected = (place: PlaceResult) => {
    setCity(place.formatted_address)
    setLatitude(place.geometry.location.lat().toString())
    setLongitude(place.geometry.location.lng().toString())
    if (props.autosubmit && input.current)
      setTimeout(() => input.current.form.submit(), 10)
  }

  return (
    <>
      <Autocomplete
        className={`LocationSelector text-input large ${props.class || ""}`}
        apiKey="AIzaSyAj_d9mLSJyQkQYNobEfqTY95bMmI2YTps"
        onPlaceSelected={handlePlaceSelected}
        defaultValue={props.city}
        options={{ fields: ["geometry.location", "formatted_address"] }}
        onFocus={(event) => setTimeout(() => event.target.select(), 10)}
        placeholder={props.placeholder || "Enter your location"}
        ref={input}
      />
      <input
        type="hidden"
        name={props.modelName ? `${props.modelName}[city]` : "city"}
        value={city}
      />
      <input
        type="hidden"
        name={props.modelName ? `${props.modelName}[latitude]` : "latitude"}
        value={latitude}
      />
      <input
        type="hidden"
        name={props.modelName ? `${props.modelName}[longitude]` : "longitude"}
        value={longitude}
      />
    </>
  )
}
