import "./ModderSelector.scss"

import React from "react"
import Select, { ControlProps, OptionProps, components } from "react-select"
import classNames from "classnames"

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

interface ModderOption {
  readonly value: string
  readonly label: string
  readonly logoUrl: string
}

const handleOptionSelected = (option: ModderOption) => {
  window.location.href = option.value
}

const Control = (props: ControlProps) => {
  return (
    <components.Control {...props}>
      <SearchIcon />
      {props.children}
    </components.Control>
  )
}

const Option = (props: OptionProps<ModderOption>) => {
  return (
    <div
      {...props.innerProps}
      className={classNames(props.className, "modder-selector__option", {
        "modder-selector__option--is-focused": props.isFocused,
      })}
    >
      <figure
        className="logo"
        style={{
          backgroundImage: props.data.logoUrl
            ? `url(${props.data.logoUrl})`
            : null,
        }}
      >
        {!props.data.logoUrl && <GccIcon />}
      </figure>
      <span>{props.data.label}</span>
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
      captureMenuScroll={true}
      closeMenuOnSelect={false}
      controlShouldRenderValue={false}
      escapeClearsValue={true}
      openMenuOnFocus={false}
      openMenuOnClick={false}
      tabSelectsValue={false}
      isClearable={false}
      backspaceRemovesValue={false}
      noOptionsMessage={() => "No results"}
      onChange={handleOptionSelected}
    />
  )
}
