import "./ServiceSelector.scss"

import React, {
  MouseEventHandler,
  useState
} from "react"
import Select, {
  components,
  MultiValueGenericProps,
  MultiValueProps,
  OnChangeValue,
  Props,
} from "react-select";
import {
  SortableContainer,
  SortableContainerProps,
  SortableElement,
  SortEndHandler,
  SortableHandle,
} from "react-sortable-hoc";

interface ServiceOption {
  readonly value: string;
  readonly label: string;
  readonly color: string;
}

function arrayMove<T>(array: readonly T[], from: number, to: number) {
  const slicedArray = array.slice();
  slicedArray.splice(
    to < 0 ? array.length + to : to,
    0,
    slicedArray.splice(from, 1)[0]
  );
  return slicedArray;
}

const SortableMultiValue = SortableElement(
  (props: MultiValueProps<ServiceOption>) => {
    const onMouseDown: MouseEventHandler<HTMLDivElement> = (e) => {
      e.preventDefault();
      e.stopPropagation();
    };
    const innerProps = { ...props.innerProps, onMouseDown };
    return <components.MultiValue {...props} innerProps={innerProps} />;
  }
);

const SortableMultiValueLabel = SortableHandle(
  (props: MultiValueGenericProps) => <components.MultiValueLabel {...props} />
);

const SortableSelect = SortableContainer(Select) as React.ComponentClass<
  Props<ServiceOption, true> & SortableContainerProps
>;

interface ServiceSelectorProps {
  readonly allServices: ServiceOption[]
  readonly modderServices: ServiceOption[],
  readonly fieldName: string
}

export default (props: ServiceSelectorProps) => {

  const [selectedServices, setSelectedServices] = useState<readonly ServiceOption[]>(props.modderServices)

  const onChange = (selectedOptions: OnChangeValue<ServiceOption, true>) => setSelectedServices(selectedOptions);
  const onSortEnd: SortEndHandler = ({ oldIndex, newIndex }) => {
    const newValue = arrayMove(selectedServices, oldIndex, newIndex);
    setSelectedServices(newValue);
  };

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
        }}
        closeMenuOnSelect={false}
        unstyled
        className="ServiceSelector"
        classNamePrefix="service-selector"
      />
      <input
        type="hidden"
        name={props.fieldName}
        value={JSON.stringify(selectedServices.map(service => service.value))}
      />
    </div>
  )

}
