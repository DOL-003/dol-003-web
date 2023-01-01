import "./ModderMap.scss"

import React, { useEffect, useRef, useState } from "react"
import Map, { Source, Layer, Marker, MapLayerMouseEvent } from "react-map-gl"

import PinIcon from "@/icons/map-pin.svg"
import { Popup } from "mapbox-gl"

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
  readonly mapPinImageUrl?: string
  readonly mapVisible?: boolean
}

export default (props: ModderMapProps) => {
  const map = useRef()
  const [mapEnabled, setMapEnabled] = useState(props.mapVisible)

  useEffect(() => {
    document.addEventListener("map-visible", () => {
      setMapEnabled(true)
    })
  }, [])

  function handleMapLoad() {
    if (props.modders) {
      let minLatitude: number,
        maxLatitude: number,
        minLongitude: number,
        maxLongitude: number

      props.modders.forEach((modder) => {
        if (!minLatitude || parseFloat(modder.latitude) < minLatitude)
          minLatitude = parseFloat(modder.latitude)
        if (!maxLatitude || parseFloat(modder.latitude) > maxLatitude)
          maxLatitude = parseFloat(modder.latitude)
        if (!minLongitude || parseFloat(modder.longitude) < minLongitude)
          minLongitude = parseFloat(modder.longitude)
        if (!maxLongitude || parseFloat(modder.longitude) > maxLongitude)
          maxLongitude = parseFloat(modder.longitude)
      })

      const latitudePadding = (maxLatitude - minLatitude) * 0.2
      const longitudePadding = (maxLongitude - minLongitude) * 0.2

      if (map.current) {
        // add custom icon
        map.current.loadImage(props.mapPinImageUrl, (error, image) => {
          map.current.addImage("modder", image)
        })

        // set up click handler
        map.current.on(
          "click",
          "modder-points",
          (event: MapLayerMouseEvent) => {
            if (event.features[0]) {
              window.location = event.features[0].properties.url
            }
          }
        )

        const modderNamePopup = new Popup({
          closeButton: false,
          closeOnClick: false,
          className: "modder-name-popup",
          anchor: "top",
        })

        // set up popup handlers
        map.current.on(
          "mouseenter",
          "modder-points",
          (event: MapLayerMouseEvent) => {
            map.current.getCanvas().style.cursor = "pointer"

            const coordinates = event.features[0].geometry.coordinates.slice()

            while (Math.abs(event.lngLat.lng - coordinates[0]) > 180) {
              coordinates[0] += event.lngLat.lng > coordinates[0] ? 360 : -360
            }

            modderNamePopup
              .setLngLat(coordinates)
              .setHTML(event.features[0].properties.name)
              .addTo(map.current.getMap())
          }
        )

        map.current.on("mouseleave", "modder-points", () => {
          map.current.getCanvas().style.cursor = ""
          modderNamePopup.remove()
        })

        // pan/zoom to show all modders
        map.current.fitBounds([
          {
            lng: maxLongitude + longitudePadding,
            lat: minLatitude - latitudePadding,
          },
          {
            lng: minLongitude - longitudePadding,
            lat: maxLatitude + latitudePadding,
          },
        ])
      }
    }
  }

  function getModderGeoJson() {
    return {
      type: "FeatureCollection",
      features: props.modders.map((modder) => ({
        id: modder.slug,
        type: "Feature",
        geometry: {
          type: "Point",
          coordinates: [modder.longitude, modder.latitude],
        },
        properties: {
          name: modder.name,
          url: modder.url,
        },
      })),
    }
  }

  if (mapEnabled === false) return <div className="ModderMap" />

  return (
    <div className="ModderMap">
      <Map
        mapboxAccessToken="pk.eyJ1Ijoiam1hcnF1aXMiLCJhIjoiY2xjNWI5Z25vMGFiOTNvbDduMm1xdjd6OSJ9.sIvPPG3HemKrXvtW-fVqYg"
        initialViewState={{
          longitude: parseFloat(props.longitude) || -94.5785667,
          latitude: parseFloat(props.latitude) || 39.0997265,
          zoom: 7,
        }}
        interactive={props.interactive || false}
        style={{ width: "100%", height: "100%" }}
        mapStyle="mapbox://styles/mapbox/light-v11"
        ref={map}
        onLoad={handleMapLoad}
      >
        {(() => {
          if (props.modders)
            return (
              <>
                <Source
                  id="modder-data"
                  type="geojson"
                  data={getModderGeoJson()}
                  cluster={true}
                >
                  <Layer
                    id="modder-points"
                    type="symbol"
                    layout={{
                      "icon-image": "modder",
                      "icon-anchor": "bottom",
                      "icon-size": 0.5,
                    }}
                  />
                </Source>
              </>
            )
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
