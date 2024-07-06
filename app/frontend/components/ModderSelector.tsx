import "./ModderSelector.scss"

import React from "react"
import Select, { ControlProps, OptionProps, components } from "react-select"

import GccIcon from "@/icons/gcc.svg"
import SearchIcon from "@/icons/search.svg"

interface ModderSelectorProps {
  readonly modders: [
    {
      name: string
      logoUrl: string
      link: string
    },
  ]
}

interface ModderOptionProps {
  readonly value: string
  readonly label: string
  readonly logoUrl: string
}

const Control = (props: ControlProps) => {
  return (
    <components.Control {...props}>
      <SearchIcon />
      {props.children}
    </components.Control>
  )
}

const Option = (props: OptionProps<ModderOptionProps>) => {
  return (
    <div {...props.innerProps} className="modder-selector__option">
      <figure>
        {(props.data.logoUrl && <img src={props.data.logoUrl} />) || (
          <GccIcon />
        )}
      </figure>
      {props.data.label}
    </div>
  )
}

export default (props: ModderSelectorProps) => {
  return (
    <Select
      options={props.modders.map((modder) => ({
        label: modder.name,
        value: modder.link,
        logoUrl: modder.logoUrl,
      }))}
      unstyled={true}
      placeholder="Jump to a modder"
      components={{ Control, Option }}
      classNamePrefix="modder-selector"
      className="ModderSelector"
    />
  )
}
