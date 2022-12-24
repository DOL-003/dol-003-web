import "./LocationSelector.scss"

import React from "react"
import Autocomplete from "react-google-autocomplete"

interface LocationSelectorProps {

}

export default (props: LocationSelectorProps) => {
  return (
    <Autocomplete
      apiKey="AIzaSyAj_d9mLSJyQkQYNobEfqTY95bMmI2YTps"
      onPlaceSelected={place => console.log(place, place.geometry.location.lat(), place.geometry.location.lng())}
    />
  )
}
