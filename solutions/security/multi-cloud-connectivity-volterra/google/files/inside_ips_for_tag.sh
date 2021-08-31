#!/bin/sh
#
eval "$(jq -r '@sh "_TAG=\(.tag) _GCP_PROJ=\(.project)"')"
if [ -z "${_TAG}" ] || [ "${_TAG}" = "null" ] || [ -z "${_GCP_PROJ}" ] || [ "${_GCP_PROJ}" = "null" ]; then
    echo '{"addresses":""}'
    exit 0
fi
gcloud compute instances list \
        --project="${_GCP_PROJ}" \
        --filter="tags.items=${_TAG}" \
        --format='value(networkInterfaces[1].networkIP)' | \
    jq -nR '{"addresses": [inputs | select(length>0)] | join(",")}'
