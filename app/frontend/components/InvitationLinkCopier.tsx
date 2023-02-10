import "./InvitationLinkCopier.scss"

import React, { useState } from "react"

interface InvitationLinkCopierProps {
  invitationsPath: string
  csrfToken: string
}

export default (props: InvitationLinkCopierProps) => {
  const [inviteLink, setInviteLink] = useState()
  const [inviteLinkCopied, setInviteLinkCopied] = useState(false)

  async function getInviteLink() {
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
      setInviteLink(data.invitation_url)

      if (data.available_invitations !== null) {
        document.querySelector("#available-invitations").innerHTML =
          data.available_invitations === 1
            ? "1 invitations"
            : `${data.available_invitations} invitations`
      }
    }
  }

  function copyInviteLink() {
    navigator.clipboard.writeText(inviteLink)
    setInviteLinkCopied(true)

    setTimeout(() => {
      setInviteLinkCopied(false)
      setInviteLink(null)
    }, 10000)
  }

  return (
    <div>
      {inviteLink ? (
        <>
          <input
            type="text"
            value={inviteLink}
            disabled={true}
            className="text-input xlarge"
          />
          <br />
          <button
            type="button"
            className="button"
            disabled={inviteLinkCopied}
            onClick={copyInviteLink}
          >
            {inviteLinkCopied ? "Copied" : "Copy link"}
          </button>
        </>
      ) : (
        <button type="button" className="button" onClick={getInviteLink}>
          {inviteLinkCopied ? "Invitation link copied" : "Generate invite link"}
        </button>
      )}
    </div>
  )
}
