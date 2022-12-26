import "./LocationSelector.scss"

import React, { useState } from "react"
import Autocomplete from "react-google-autocomplete"

interface LocationSelectorProps {
  readonly modelName: string
  readonly city: string
  readonly latitude: string
  readonly longitude: string
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

  const handlePlaceSelected = (place: PlaceResult) => {
    setCity(place.formatted_address)
    setLatitude(place.geometry.location.lat().toString())
    setLongitude(place.geometry.location.lng().toString())
  }

  return (
    <>
      <Autocomplete
        className="LocationSelector text-input large"
        apiKey="AIzaSyAj_d9mLSJyQkQYNobEfqTY95bMmI2YTps"
        onPlaceSelected={handlePlaceSelected}
        defaultValue={props.city}
        options={{ fields: ["geometry.location", "formatted_address"] }}
        onFocus={(event) => event.target.select()}
      />
      <input type="hidden" name={`${props.modelName}[city]`} value={city} />
      <input
        type="hidden"
        name={`${props.modelName}[latitude]`}
        value={latitude}
      />
      <input
        type="hidden"
        name={`${props.modelName}[longitude]`}
        value={longitude}
      />
    </>
  )
}
