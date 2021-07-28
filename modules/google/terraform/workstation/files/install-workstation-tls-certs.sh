#!/bin/sh
#
# Install TLS certificate set from Google Secret Manager

error()
{
    echo "$0: ERROR: $*" >&2
    exit 1
}

secret_file="$(mktemp).json" || \
    error "Unable to create temporary secret file: exit code $?"
auth_token="$(curl -sf --retry 20 -H 'Metadata-Flavor: Google' 'http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token' | jq --raw-output '.access_token')" || \
    error "Unable to retrieve GCP authentication token: exit code $?"
project_id="$(curl -sf --retry 20 -H 'Metadata-Flavor: Google' "http://169.254.169.254/computeMetadata/v1/project/project-id?alt=text")" || \
    error "Unable to retrieve GCP project ID: exit code $?"
curl -sk --retry 20 -H "Authorization: Bearer ${auth_token}" "https://secretmanager.googleapis.com/v1/projects/${project_id}/secrets/${1}/versions/${2:-latest}:access" 2>/dev/null | \
    jq -r '.payload.data' 2>/dev/null | base64 -d 2>/dev/null > "${secret_file}" || \
    error "Error fetching and/or decoding secret: exit code $?"
jq -r '.cert' < "${secret_file}" > /etc/ssl/certs/workstation.pem || \
    "Error extracting TLS certificate: exit code $?"
jq -r '.key' < "${secret_file}" > /etc/ssl/private/workstation.key || \
    "Error extracting TLS key: exit code $?"
chown root:root /etc/ssl/certs/workstation.pem /etc/ssl/private/workstation.key
chmod 0644 /etc/ssl/certs/workstation.pem
chmod 0640 /etc/ssl/private/workstation.key
if jq -re '.ca' < "${secret_file}" >/dev/null 2>/dev/null; then
    jq -r '.ca' < "${secret_file}" > /usr/local/share/ca-certificates/workstation-ca.pem || \
        error "Error extracting CA certificate: exit code $?"
    chown root:root /usr/local/share/ca-certificates/workstation-ca.pem
    chmod 0644 /usr/local/share/ca-certificates/workstation-ca.pem
    /usr/sbin/update-ca-certificates
fi
rm -f "${secret_file}"
