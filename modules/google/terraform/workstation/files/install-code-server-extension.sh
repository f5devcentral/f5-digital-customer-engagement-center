#!/bin/sh
#
# Install the vsix extension for code-server from URL

error()
{
    echo "$0: ERROR: $*" >&2
    exit 1
}

# TODO: @memes - Code Server seems to need files to have .vsix extension. Confirm.
VSIX="$(mktemp).vsix" || error "Unable to create temporary download file: $?"
case "$1" in
    gs://*)
        gsutil cp "$1" "${VSIX}" || \
            error "Unable to download from GCS: $1: $?"
            ;;
    https://storage.googleapis.com/*)
        curl -sSLo "${VSIX}" \
            -H "Authorization: Bearer $(curl -sf --retry 20 -H 'Metadata-Flavor: Google' 'http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token' | jq --raw-output '.access_token'))" \
            "$1" || \
            error "Unable to download from GCS: $1: $?"
        ;;
    *api.github.com*)
        curl -sSLo "${VSIX}" $(curl -sSL "$1" | jq -r '.assets[] | select(.name | contains (".vsix")) | .browser_download_url') || \
            error "Unable to download release from GitHub: $1: $?"
        ;;
    *)
        curl -sSLo "${VSIX}" "$1" || error "Unable to download from $1: $?"
        ;;
esac
/usr/bin/code-server --install-extension "${VSIX}" || \
    error "Failed to install ${VSIX}: $?"
rm -f "${VSIX}"

exit 0
