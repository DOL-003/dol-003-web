import "./QuickSearch.scss"

import React, { useState } from "react"
import Select, { ControlProps, OptionProps, components } from "react-select"
import classNames from "classnames"

import GccIcon from "@/icons/gcc.svg"
import PageIcon from "@/icons/page.svg"
import SearchIcon from "@/icons/search.svg"
import PinIcon from "@/icons/pin.svg"

type Modder = {
  readonly type: "modder"
  readonly name: string
  readonly logoUrl: string
  readonly link: string
  readonly city: string
}

type Page = {
  readonly type: "page"
  readonly title: string
  readonly subtitle: string
  readonly slug: string
}

interface QuickSearchProps {
  readonly modders: [Modder]
  readonly pages: [Page]
  readonly compendiumDomain: string
}

const handleOptionSelected = (
  option: Modder | Page,
  compendiumDomain: string,
) => {
  switch (option.type) {
    case "page":
      window.location.href = `${compendiumDomain}${option.slug}`
      break
    case "modder":
      window.location.href = option.link
      break
  }
}

const Control = (props: ControlProps) => {
  return (
    <components.Control {...props}>
      <SearchIcon />
      {props.children}
    </components.Control>
  )
}

const Option = (props: OptionProps<Modder | Page>) => {
  return (
    <div
      {...props.innerProps}
      className={classNames(props.className, "quick-search__option", {
        "quick-search__option--is-focused": props.isFocused,
      })}
    >
      {(() => {
        if (props.data.type === "modder") {
          return (
            <>
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
              <div>
                <h3>
                  {props.data.name} blah blah blah blah blah blah blah blah
                </h3>
                <p className="city">
                  <PinIcon />
                  {props.data.city}
                </p>
              </div>
            </>
          )
        } else if (props.data.type === "page") {
          return (
            <>
              <div>hi</div>
            </>
          )
        }
      })()}
    </div>
  )
}

export default (props: QuickSearchProps) => {
  const [open, setOpen] = useState(false)
  return (
    <>
      <Select
        options={[
          ...props.modders.map((modder) => ({ type: "modder", ...modder })),
          ...props.pages.map((page) => ({ type: "page", ...page })),
        ]}
        unstyled={true}
        placeholder={
          open ? "Search modders and Compendium pages" : "Quick search"
        }
        components={{ Control, Option }}
        classNamePrefix="quick-search"
        className={classNames("QuickSearch", { open })}
        captureMenuScroll={true}
        closeMenuOnSelect={false}
        controlShouldRenderValue={false}
        escapeClearsValue={false}
        openMenuOnFocus={true}
        openMenuOnClick={true}
        tabSelectsValue={false}
        isClearable={false}
        backspaceRemovesValue={false}
        noOptionsMessage={() => "No results"}
        onChange={(option) =>
          handleOptionSelected(option, props.compendiumDomain)
        }
        onFocus={() => setOpen(true)}
        onBlur={() => setOpen(false)}
        menuIsOpen={open}
      />
      <div className={classNames("quicksearch-backdrop", { open })} />
    </>
  )
}
