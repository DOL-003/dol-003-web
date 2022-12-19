import React from "react"

interface Service {
  readonly value: string;
  readonly label: string;
  readonly color: string;
  readonly isFixed?: boolean;
  readonly isDisabled?: boolean;
}

const services: Service[] = [

]

export default props => {
  return <div>hello! {props.test}</div>
}
