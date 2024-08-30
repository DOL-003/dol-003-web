import "./QuickSearch.scss"

import React, { useState, useEffect, useRef } from "react"
import { ControlProps, OptionProps, components } from "react-select"
import AsyncSelect from "react-select/async"
import classNames from "classnames"

import GccIcon from "@/icons/gcc.svg"
import PageIcon from "@/icons/page.svg"
import SearchIcon from "@/icons/search.svg"
import PinIcon from "@/icons/pin.svg"

type Modder = {
  readonly type: "modder"
  readonly slug: string
  readonly name: string
  readonly logoUrl: string
  readonly link: string
  readonly city: string
}

type Page = {
  readonly type: "page"
  readonly slug: string
  readonly title: string
  readonly subtitle: string
}

interface QuickSearchProps {
  readonly modders: [Modder]
  readonly pages: [Page]
  readonly recentSlugs?: [string]
  readonly slug: string
  readonly compendiumDomain: string
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
      ref={props.innerRef}
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
                <h3>{props.data.name}</h3>
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
              <figure>
                <PageIcon />
              </figure>
              <div>
                <h3>{props.data.title}</h3>
                <p>{props.data.subtitle}</p>
              </div>
            </>
          )
        }
      })()}
    </div>
  )
}

const filterOptions = (
  options: (Modder | Page)[],
  inputValue: string,
  recentSlugs?: [string],
) => {
  let optionsWithScores = options.reduce((optionsWithScores, option) => {
    let score = 0

    switch (option.type) {
      case "modder":
        if (
          inputValue &&
          option.name.toLowerCase().includes(inputValue.toLowerCase())
        )
          score += 100
        if (
          inputValue &&
          option.name.toLowerCase().indexOf(inputValue.toLowerCase()) === 0
        )
          score += 100 - option.name.length
        if (
          inputValue &&
          option.city.toLowerCase().includes(inputValue.toLowerCase())
        )
          score += 50
        if (recentSlugs && recentSlugs.includes(option.slug))
          score += 10 - recentSlugs.indexOf(option.slug)
        break
      case "page":
        if (
          inputValue &&
          option.title.toLowerCase().includes(inputValue.toLowerCase())
        )
          score += 100
        if (
          inputValue &&
          option.title.toLowerCase().indexOf(inputValue.toLowerCase()) === 0
        )
          score += 100 - option.title.length
        if (
          inputValue &&
          option.subtitle.toLowerCase().includes(inputValue.toLowerCase())
        )
          score += 50
        if (recentSlugs && recentSlugs.includes(option.slug))
          score += 10 - recentSlugs.indexOf(option.slug)
        break
    }

    return optionsWithScores.concat([
      {
        score,
        option,
      },
    ])
  }, [])

  if (inputValue) {
    optionsWithScores = optionsWithScores.filter(
      (optionWithScore) => optionWithScore.score > 0,
    )
  }

  return optionsWithScores
    .sort((a, b) => b.score - a.score)
    .map((optionWithScore) => optionWithScore.option)
}

export default (props: QuickSearchProps) => {
  const [open, setOpen] = useState(false)
  const field = useRef()

  useEffect(() => {
    document.addEventListener("keypress", (event) => {
      if (
        event.target.tagName === "input" ||
        event.target.tagName === "textarea"
      )
        return
      if (event.key !== "/") return
      field.current.focus()
      event.preventDefault()
    })
  }, [])

  const handleOpenChange = (open: boolean) => {
    document.body.scrollTo(0, 0)
    document.body.classList.toggle("scroll-locked", open)
    setOpen(open)
  }

  const loadOptions = (inputValue: string) => {
    const options = [
      ...props.modders.map((modder) => ({
        type: "modder",
        value: `${modder.name} ${modder.city}`,
        ...modder,
      })),
      ...props.pages.map((page) => ({
        type: "page",
        value: `${page.title} ${page.subtitle}`,
        ...page,
      })),
    ]

    return new Promise<(Modder | Page)[]>((resolve) => {
      resolve(filterOptions(options, inputValue, props.recentSlugs))
    })
  }

  const handleOptionSelected = (
    option: Modder | Page,
    compendiumDomain: string,
  ) => {
    setOpen(false)
    switch (option.type) {
      case "page":
        window.location.href = `${compendiumDomain}${option.slug}`
        break
      case "modder":
        window.location.href = option.link
        break
    }
  }

  return (
    <>
      <AsyncSelect
        ref={field}
        loadOptions={loadOptions}
        defaultOptions
        unstyled={true}
        placeholder={
          open
            ? window.innerWidth <= 960
              ? "Search modders and pages"
              : "Search modders and Compendium pages"
            : "Quick search"
        }
        components={{ Control, Option }}
        classNamePrefix="quick-search"
        className={classNames("QuickSearch", { open })}
        captureMenuScroll={true}
        closeMenuOnSelect={true}
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
        onFocus={() => handleOpenChange(true)}
        onBlur={() => handleOpenChange(false)}
        onKeyDown={(event) =>
          event.key === "Escape" && field.current && field.current.blur()
        }
        menuIsOpen={open}
      />
      <div className={classNames("quicksearch-backdrop", { open })} />
    </>
  )
}
