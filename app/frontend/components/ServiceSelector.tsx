import "./ServiceSelector.scss"

import React, { MouseEventHandler, useState } from "react"
import Select, {
  components,
  MultiValueGenericProps,
  MultiValueProps,
  OnChangeValue,
  OptionProps,
  Props,
} from "react-select"
import {
  SortableContainer,
  SortableContainerProps,
  SortableElement,
  SortEndHandler,
  SortableHandle,
} from "react-sortable-hoc"

interface ServiceOption {
  readonly value: string
  readonly label: string
  readonly color: string
  readonly colorDark: string
  readonly solid?: boolean
}

function arrayMove<T>(array: readonly T[], from: number, to: number) {
  const slicedArray = array.slice()
  slicedArray.splice(
    to < 0 ? array.length + to : to,
    0,
    slicedArray.splice(from, 1)[0]
  )
  return slicedArray
}

const SortableMultiValue = SortableElement(
  (props: MultiValueProps<ServiceOption>) => {
    const onMouseDown: MouseEventHandler<HTMLDivElement> = (e) => {
      e.preventDefault()
      e.stopPropagation()
    }
    const innerProps = { ...props.innerProps, onMouseDown }
    const className =
      (props.className || "") + (props.data.solid ? " solid" : "")
    return (
      <components.MultiValue
        {...props}
        innerProps={innerProps}
        className={className}
      />
    )
  }
)

const SortableMultiValueLabel = SortableHandle(
  (props: MultiValueGenericProps) => <components.MultiValueLabel {...props} />
)

const SortableSelect = SortableContainer(Select) as React.ComponentClass<
  Props<ServiceOption, true> & SortableContainerProps
>

const ServiceOptionComponent = (props: OptionProps<ServiceOption>) => {
  const innerProps = {
    ...props.innerProps,
    className:
      (props.innerProps.className ||
        props.className ||
        "service-selector__option") + (props.data.solid ? " solid" : ""),
  }
  return <components.Option {...props} innerProps={innerProps} />
}

interface ServiceSelectorProps {
  readonly allServices: ServiceOption[]
  readonly selectedServices: ServiceOption[]
  readonly fieldName: string
  readonly commaDelimited?: boolean
}

export default (props: ServiceSelectorProps) => {
  const [selectedServices, setSelectedServices] = useState<
    readonly ServiceOption[]
  >(props.selectedServices)

  const onChange = (selectedOptions: OnChangeValue<ServiceOption, true>) =>
    setSelectedServices(selectedOptions)
  const onSortEnd: SortEndHandler = ({ oldIndex, newIndex }) => {
    const newValue = arrayMove(selectedServices, oldIndex, newIndex)
    setSelectedServices(newValue)
  }

  return (
    <div className="ServiceSelector">
      <SortableSelect
        useDragHandle
        // react-sortable-hoc props:
        axis="xy"
        onSortEnd={onSortEnd}
        distance={4}
        // small fix for https://github.com/clauderic/react-sortable-hoc/pull/352:
        getHelperDimensions={({ node }) => node.getBoundingClientRect()}
        // react-select props:
        isMulti
        options={props.allServices}
        value={selectedServices}
        onChange={onChange}
        components={{
          // @ts-ignore We're failing to provide a required index prop to SortableElement
          MultiValue: SortableMultiValue,
          MultiValueLabel: SortableMultiValueLabel,
          Option: ServiceOptionComponent,
        }}
        closeMenuOnSelect={false}
        unstyled
        className="ServiceSelector"
        classNamePrefix="service-selector"
        styles={{
          option: (styles, { data }) => {
            return {
              ...styles,
              "--service-color": data.color,
              "--service-color-dark": data.colorDark,
            }
          },
          multiValue: (styles, { data }) => {
            return {
              ...styles,
              "--service-color": data.color,
              "--service-color-dark": data.colorDark,
            }
          },
        }}
      />
      <input
        type="hidden"
        name={props.fieldName}
        value={
          props.commaDelimited
            ? selectedServices.map((service) => service.value).join(",")
            : JSON.stringify(selectedServices.map((service) => service.value))
        }
      />
    </div>
  )
}
