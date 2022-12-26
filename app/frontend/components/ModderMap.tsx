import "./ModderMap.scss"

import React from "react"
import Map, { Marker } from "react-map-gl"

import MapIcon from "@/icons/map-pin.svg"

interface ModderMapProps {
  readonly latitude: string
  readonly longitude: string
}

export default (props: ModderMapProps) => {
  return (
    <div className="ModderMap">
      <Map
        mapboxAccessToken="pk.eyJ1Ijoiam1hcnF1aXMiLCJhIjoiY2xjNWI5Z25vMGFiOTNvbDduMm1xdjd6OSJ9.sIvPPG3HemKrXvtW-fVqYg"
        initialViewState={{
          longitude: parseFloat(props.longitude),
          latitude: parseFloat(props.latitude),
          zoom: 7,
        }}
        interactive={false}
        style={{ width: "100%", height: "30vw", minHeight: "300px" }}
        mapStyle="mapbox://styles/mapbox/light-v11"
      >
        <Marker
          latitude={parseFloat(props.latitude)}
          longitude={parseFloat(props.longitude)}
          anchor="bottom"
        >
          <MapIcon />
        </Marker>
      </Map>
    </div>
  )
}
