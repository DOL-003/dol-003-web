import "./InvitationLinkCopier.scss"

import React, { useState } from "react"

interface InvitationLinkCopierProps {
  invitationsPath: string
  csrfToken: string
}

export default (props: InvitationLinkCopierProps) => {
  const [inviteLinkCopied, setInviteLinkCopied] = useState(false)

  async function copyInvitationLink() {
    const response = await fetch(props.invitationsPath, {
      headers: {
        "X-CSRF-Token": props.csrfToken,
        "Content-Type": "application/json",
        Accept: "application/json",
      },
      method: "post",
    })
    const data = await response.json()

    if (data.success) {
      navigator.clipboard.writeText(data.invitation_url)
      setInviteLinkCopied(true)

      document.querySelector("#available-invitations").innerHTML =
        data.available_invitations === 1
          ? "1 invitations"
          : `${data.available_invitations} invitations`

      setTimeout(() => setInviteLinkCopied(false), 10000)
    }
  }

  return (
    <div>
      <button
        type="button"
        className="button"
        onClick={copyInvitationLink}
        disabled={inviteLinkCopied}
      >
        {inviteLinkCopied ? "Invitation link copied" : "Copy invitation link"}
      </button>
    </div>
  )
}
