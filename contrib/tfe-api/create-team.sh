#!/bin/bash
set -eu

[[ "$#" -ne 1 ]] && { echo "usage: $0 <team-name>" ; exit 1; }

TEAM=$1

# PLEASE configure
TFE_HOSTNAME=tfe.pythonrocks.dev
TFE_ORG=cdw
# PLEASE configure

ENDPOINT_BASE_URL="https://${TFE_HOSTNAME}/api/v2/"
TFE_TOKEN="$(gcloud secrets versions access latest --secret=TFE_TOKEN)"

if [ ! -z "$TFE_TOKEN" ]; then
  echo "TFE_TOKEN environment variable was found."
else
  echo "TFE_TOKEN environment variable was not set."
  echo "You must export/set the TFE_TOKEN environment variable."
  echo "It should be a user or team token that has write or admin"
  echo "permission on the workspace."
  echo "Exiting."
  exit
fi

generate_team_data()
{
  cat <<EOF
{
  "data": {
    "type": "teams",
    "attributes": {
      "name": "${TEAM}",
      "organization-access": {
        "manage-workspaces": true
      }
    }
  }
}
EOF
}



curl -s \
  --header "Authorization: Bearer ${TFE_TOKEN}" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data  "$(generate_team_data)" \
  ${ENDPOINT_BASE_URL}/organizations/${TFE_ORG}/teams | jq . 

curl  -s \
  --header "Authorization: Bearer ${TFE_TOKEN}" \
  --header "Content-Type: application/vnd.api+json" \
  --request GET \
 ${ENDPOINT_BASE_URL}/organizations/${TFE_ORG}/teams | jq .


