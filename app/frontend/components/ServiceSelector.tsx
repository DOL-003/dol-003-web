import React from "react"

interface Service {
  readonly name: string;
  readonly color: string;
}

interface ServiceSelectorProps {
  readonly services: Service[]
}

const services: Service[] = [

]

export default (props: ServiceSelectorProps) => {
  return (
    <div className="ServiceSelector">
      {props.services.map(service => <p>Service: {service.name}</p>)}
    </div>
  )
}
