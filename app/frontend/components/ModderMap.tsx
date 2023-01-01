import "./ModderMap.scss"

import React, { useEffect, useRef, useState } from "react"
import Map, {
  Source,
  Layer,
  Marker,
  MapLayerMouseEvent,
  NavigationControl,
} from "react-map-gl"

import PinIcon from "@/icons/map-pin.svg"
import { Popup } from "mapbox-gl"

interface Modder {
  readonly url: string
  readonly slug: string
  readonly name: string
  readonly city: string
  readonly latitude: string
  readonly longitude: string
}

interface ModderMapProps {
  readonly latitude: string
  readonly longitude: string
  readonly modders?: Modder[]
  readonly interactive?: boolean
  readonly mapPinImageUrl?: string
  readonly mapVisible?: boolean
}

const modderSplayProximityThreshold = 0.01
const modderSplayDistance = 0.01
let splayedModders: Modder[]

function splayModders(modders: Modder[]) {
  if (splayedModders) return splayedModders

  const modderGroups = []
  for (let i = 0; i < modders.length; i++) {
    modderGroups[i] = [i]
    for (let j = i; j < modders.length; j++) {
      if (modders[i].slug === modders[j].slug) continue

      if (
        Math.abs(
          parseFloat(modders[j].latitude) - parseFloat(modders[i].latitude)
        ) < modderSplayProximityThreshold &&
        Math.abs(
          parseFloat(modders[j].longitude) - parseFloat(modders[j].longitude)
        ) < modderSplayProximityThreshold
      ) {
        modderGroups[i] = modderGroups[i].concat([j])
      }
    }
  }

  const moddersCopy = modders.slice()
  for (let i = 0; i < modderGroups.length; i++) {
    if (modderGroups[i].length === 1) continue

    const originLatitude = parseFloat(modders[modderGroups[i][0]].latitude)
    const originLongitude = parseFloat(modders[modderGroups[i][0]].longitude)
    const angle = (2 * Math.PI) / modderGroups[i].length

    for (let j = 0; j < modderGroups[i].length; j++) {
      moddersCopy[modderGroups[i][j]].longitude = (
        originLongitude +
        modderSplayDistance * Math.cos(j * angle)
      ).toString()
      moddersCopy[modderGroups[i][j]].latitude = (
        originLatitude +
        modderSplayDistance * Math.sin(j * angle)
      ).toString()
    }
  }

  return (splayedModders = moddersCopy)
}

let minLatitude: number,
  maxLatitude: number,
  minLongitude: number,
  maxLongitude: number,
  latitudePadding: number = 0,
  longitudePadding: number = 0,
  initialLatitude: number = 0,
  initialLongitude: number = 0

export default (props: ModderMapProps) => {
  const map = useRef()
  const [mapEnabled, setMapEnabled] = useState(props.mapVisible)

  const modders = props.modders ? splayModders(props.modders) : null

  useEffect(() => {
    document.addEventListener("map-visible", () => {
      setMapEnabled(true)
    })

    if (modders) {
      modders.forEach((modder) => {
        if (!minLatitude || parseFloat(modder.latitude) < minLatitude)
          minLatitude = parseFloat(modder.latitude)
        if (!maxLatitude || parseFloat(modder.latitude) > maxLatitude)
          maxLatitude = parseFloat(modder.latitude)
        if (!minLongitude || parseFloat(modder.longitude) < minLongitude)
          minLongitude = parseFloat(modder.longitude)
        if (!maxLongitude || parseFloat(modder.longitude) > maxLongitude)
          maxLongitude = parseFloat(modder.longitude)

        initialLatitude += parseFloat(modder.latitude)
        initialLongitude += parseFloat(modder.longitude)
      })

      initialLatitude = initialLatitude / modders.length
      initialLongitude = initialLongitude / modders.length
      latitudePadding = (maxLatitude - minLatitude) * 0.3
      longitudePadding = (maxLongitude - minLongitude) * 0.3
    }
  }, [])

  function handleMapLoad() {
    // stuff to do only for the multi modder map
    if (modders && map.current) {
      // add custom icon
      map.current.loadImage(props.mapPinImageUrl, (error, image) => {
        map.current.addImage("modder", image)
      })

      // set up modder click handler
      map.current.on("click", "modder-points", (event: MapLayerMouseEvent) => {
        if (event.features[0]) {
          window.location = event.features[0].properties.url
        }
      })

      // set up cluster click handler
      map.current.on(
        "click",
        "modder-clusters",
        (event: MapLayerMouseEvent) => {
          const feature = event.features[0]
          map.current
            .getSource("modder-data")
            .getClusterExpansionZoom(
              feature.properties.cluster_id,
              (error, zoom) => {
                if (error) return

                map.current.easeTo({
                  center: feature.geometry.coordinates,
                  zoom,
                })
              }
            )
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

      map.current.on("mouseenter", "modder-clusters", () => {
        map.current.getCanvas().style.cursor = "pointer"
      })

      map.current.on("mouseleave", "modder-clusters", () => {
        map.current.getCanvas().style.cursor = ""
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

  function getModderGeoJson() {
    return {
      type: "FeatureCollection",
      features: splayModders(props.modders).map((modder) => ({
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
          longitude:
            parseFloat(props.longitude) || initialLongitude || -94.5785667,
          latitude: parseFloat(props.latitude) || initialLatitude || 39.0997265,
          zoom: 7,
        }}
        interactive={props.interactive || false}
        style={{ width: "100%", height: "100%" }}
        mapStyle="mapbox://styles/mapbox/light-v11"
        ref={map}
        onLoad={handleMapLoad}
      >
        {(() => {
          if (modders)
            return (
              <>
                <NavigationControl showCompass={false} />
                <Source
                  id="modder-data"
                  type="geojson"
                  data={getModderGeoJson()}
                  cluster={true}
                >
                  <Layer
                    id="modder-points"
                    type="symbol"
                    filter={["!=", "cluster", true]}
                    layout={{
                      "icon-image": "modder",
                      "icon-anchor": "bottom",
                      "icon-size": 0.5,
                    }}
                  />
                  <Layer
                    id="modder-clusters"
                    type="circle"
                    filter={["==", "cluster", true]}
                    paint={{
                      "circle-radius": 24,
                      "circle-color": "#fdb03a",
                    }}
                  />
                  <Layer
                    id="modder-cluster-text"
                    type="symbol"
                    filter={["==", "cluster", true]}
                    layout={{
                      "text-field": ["get", "point_count"],
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
