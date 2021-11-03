#!/bin/sh
#
# Install TLS certificate set from Google Secret Manager

error()
{
    echo "$0: ERROR: $*" >&2
    exit 1
}

curl -sSLo /run/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 || \
    error "Error downloading jq: exit code $?"
chmod 0755 /run/jq || \
    error "Error setting jq file mode: exit code $?"
secret_file="$(mktemp).json" || \
    error "Unable to create temporary secret file: exit code $?"
auth_token="$(curl -sf --retry 20 -H 'Metadata-Flavor: Google' 'http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token' | /run/jq --raw-output '.access_token')" || \
    error "Unable to retrieve GCP authentication token: exit code $?"
project_id="$(curl -sf --retry 20 -H 'Metadata-Flavor: Google' "http://169.254.169.254/computeMetadata/v1/project/project-id?alt=text")" || \
    error "Unable to retrieve GCP project ID: exit code $?"
curl -sk --retry 20 -H "Authorization: Bearer ${auth_token}" "https://secretmanager.googleapis.com/v1/projects/${project_id}/secrets/${1}/versions/${2:-latest}:access" 2>/dev/null | \
    /run/jq -r '.payload.data' 2>/dev/null | base64 -d 2>/dev/null > "${secret_file}" || \
    error "Error fetching and/or decoding secret: exit code $?"
/run/jq -r '.cert' < "${secret_file}" > /var/lib/webapp/conf.d/server.pem || \
    "Error extracting TLS certificate: exit code $?"
/run/jq -r '.key' < "${secret_file}" > /var/lib/webapp/conf.d/server.key || \
    "Error extracting TLS key: exit code $?"
chown root:root /var/lib/webapp/conf.d/server.pem /var/lib/webapp/conf.d/server.key
chmod 0644 /var/lib/webapp/conf.d/server.pem
chmod 0640 /var/lib/webapp/conf.d/server.key
rm -f "${secret_file}" /run/jq
