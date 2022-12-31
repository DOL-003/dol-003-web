import "./LocationSelector.scss"

import React, { useState, useRef } from "react"
import Autocomplete from "react-google-autocomplete"

import Geolocator from "./Geolocator"
import CheckIcon from "@/icons/check.svg"
import XIcon from "@/icons/x.svg"
import Spinner from "@/icons/spinner.svg"

interface LocationSelectorProps {
  readonly modelName?: string
  readonly city?: string
  readonly latitude?: string
  readonly longitude?: string
  readonly class?: string
  readonly placeholder?: string
  readonly autosubmit?: boolean
  readonly geolocator?: boolean
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
  const [loading, setLoading] = useState(false)
  const input = useRef<HTMLInputElement>()

  function handlePlaceSelected(place: PlaceResult) {
    setCity(place.formatted_address)
    setLatitude(place.geometry.location.lat().toString())
    setLongitude(place.geometry.location.lng().toString())
    if (props.autosubmit && input.current)
      setTimeout(() => input.current.form.submit(), 10)
  }

  function handleGeolocationClick() {
    setLoading(true)
  }

  function clearGeolocation() {
    setLatitude("")
    setLongitude("")
  }

  function isUsingGeolocation() {
    return !city && !!latitude && !!longitude
  }

  function shouldShowGeolocationIndicator() {
    return loading || isUsingGeolocation()
  }

  function handleGeolocation(latitude: string, longitude: string) {
    setLoading(false)
    handlePlaceSelected({
      formatted_address: "",
      geometry: {
        location: {
          lat: () => parseFloat(latitude),
          lng: () => parseFloat(longitude),
        },
      },
    })
  }

  return (
    <div className="LocationSelector">
      {(shouldShowGeolocationIndicator() && (
        <div className="geolocation-indicator">
          <input
            type="text"
            className={`text-input ${props.class || ""}`}
            disabled={true}
            value={loading ? "" : "Using your location"}
          />
          {(loading && <Spinner className="spinner" />) || (
            <>
              <CheckIcon className="check-icon" />
              <button type="button" onClick={clearGeolocation}>
                <XIcon />
              </button>
            </>
          )}
        </div>
      )) || (
        <Autocomplete
          className={`text-input ${props.class || ""}`}
          apiKey="AIzaSyBXONaKjG3N7wn3asMP4p0xqACCNmVG4SY"
          onPlaceSelected={handlePlaceSelected}
          defaultValue={props.city}
          options={{ fields: ["geometry.location", "formatted_address"] }}
          onFocus={(event) => setTimeout(() => event.target.select(), 10)}
          placeholder={props.placeholder || "Enter your location"}
          disabled={loading}
        />
      )}
      {props.geolocator && (!latitude || !longitude || city) && !loading && (
        <Geolocator
          onLocation={handleGeolocation}
          onClick={handleGeolocationClick}
        />
      )}
      <input
        type="hidden"
        name={props.modelName ? `${props.modelName}[city]` : "city"}
        value={city}
        ref={input}
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
    </div>
  )
}
