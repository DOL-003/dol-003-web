import "./QuickSearch.scss"

import React from "react"
import Select, { ControlProps, OptionProps, components } from "react-select"
import classNames from "classnames"

import GccIcon from "@/icons/gcc.svg"
import SearchIcon from "@/icons/search.svg"

interface QuickSearchProps {
  readonly modders: [
    {
      name: string
      logoUrl: string
      link: string
    },
  ]
  readonly pages: [
    {
      slug: string
      title: string
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
      className={classNames(props.className, "quick-search__option", {
        "quick-search__option--is-focused": props.isFocused,
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

export default (props: QuickSearchProps) => {
  return (
    <Select
      options={props.modders.map((modder) => ({
        label: modder.name,
        value: modder.link,
        logoUrl: modder.logoUrl,
      }))}
      unstyled={true}
      placeholder="Quick search"
      components={{ Control, Option }}
      classNamePrefix="quick-search"
      className="QuickSearch"
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
