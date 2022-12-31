import "./ModderMap.scss"

import React from "react"
import Map, { Marker } from "react-map-gl"

import PinIcon from "@/icons/map-pin.svg"

interface ModderMapProps {
  readonly latitude: string
  readonly longitude: string
  readonly modders?: {
    readonly url: string
    readonly slug: string
    readonly name: string
    readonly city: string
    readonly latitude: string
    readonly longitude: string
  }[]
  readonly interactive?: boolean
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
        interactive={props.interactive || false}
        style={{ width: "100%", height: "100%" }}
        mapStyle="mapbox://styles/mapbox/light-v11"
      >
        {(() => {
          if (props.modders)
            return props.modders.map((modder) => (
              <Marker
                key={modder.slug}
                latitude={parseFloat(modder.latitude)}
                longitude={parseFloat(modder.longitude)}
              >
                <PinIcon />
              </Marker>
            ))
          else
            return (
              <Marker
                latitude={parseFloat(props.latitude)}
                longitude={parseFloat(props.longitude)}
                anchor="bottom"
              >
                <PinIcon />
              </Marker>
            )
        })()}
      </Map>
    </div>
  )
}
