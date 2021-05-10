#!/bin/bash
set -eux
TOKEN=$(gcloud secrets versions access latest --secret=TFE_TOKEN)
ENDPOINT_BASE_URL="https://tfe.pythonrocks.dev/api/v2/admin"
SSO_ENDPOINT_URL="https://login.microsoftonline.com/b81d7c17-75bd-4272-8b31-171ea6c31427/saml2"
SLO_ENDPOINT_URL="https://login.microsoftonline.com/b81d7c17-75bd-4272-8b31-171ea6c31427/saml2"
IDP_CERT="-----BEGIN CERTIFICATE-----\nMIIC8DCCAdigAwIBAgIQHxvaJhHnGKtD9PqpLNeVkTANBgkqhkiG9w0BAQsFADA0MTIwMAYDVQQD\nEylNaWNyb3NvZnQgQXp1cmUgRmVkZXJhdGVkIFNTTyBDZXJ0aWZpY2F0ZTAeFw0yMTAzMzEyMjU3\nMTlaFw0yNDAzMzEyMjU2MThaMDQxMjAwBgNVBAMTKU1pY3Jvc29mdCBBenVyZSBGZWRlcmF0ZWQg\nU1NPIENlcnRpZmljYXRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtGmZ6mw2Xw4l\n/tI0p3tkE6RFIzRhALGxQ/VusLRZtc0ZZvqcb7UM96CwH4KWU6NrkZohMI7+i4nn4agyzln29AGy\n5szBvt49bPiBAVDO1DfwUpP1NpWIz344/oHxNIl8UhRq6Wb+9pq4s37U7ev39oACh8nkRpcicxzo\n4KJ0OQ2s6IXCbztlxrwUZTCMONfvvtxZkgTK3fdFb9QR9oSughlXWBEFKzhgZtKp4au50e7bkF9L\n1fbpDkxhWpGtkpv8PwuIzrmd2UgK6lIZN3lQvGDG8G6CsI8FGqzMbmJ76rds4aVA9hQl71uFfrzt\nfQKYka2vbwG4hPo/8yZ6jiNc7QIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCUUdoPu5zr1ioEoGwX\nCLAS866z9eWY5tNQ+SGOxmd2FDOIHLAzuIMeujhLxh1MEbGFOgWzBSMAXB5PaC4uFYNwCxC+HzH5\nDVzK5q0XCPFGnG7WxkGK/IHFwr2wfSbIiDPftcWZlIr3fWZXEmr6xoWJaCLaNX67Q0l79nmnCJyL\nD8f12v/umXNiDIBIJi2A+a82lNdF+G3a+B/6rlNIQW31SUcF0LwpbR16iIi6Y60K8TazBkxxbnKi\nVz77tL3E2/ciFt9oiyeeb2Lm/y7Vc9nSCltRPjSMLhiULwSt8u+IhP4Q9c8AaJVZQeY6HguZkWt7\nrUgm1tFdh91mu1LO5Vd+\n-----END CERTIFICATE-----"

generate_patch_data()
{
  cat <<EOF
{
  "data": {
  "id": "saml",
  "type": "saml-settings",
  "attributes": {
    "enabled": true,
    "debug": false,
    "idp-cert":"${IDP_CERT}",
    "slo-endpoint-url":"${SLO_ENDPOINT_URL}", 
    "sso-endpoint-url":"${SSO_ENDPOINT_URL}"
    }
  }
}
EOF
}

# PATCH /api/v2/admin/smtp-settings
# Admin Update SAML Settings API Doc Reference
# <https://www.terraform.io/docs/cloud/api/admin/settings.html#update-saml-settings>
     
curl -s \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request PATCH \
  --data  "$(generate_patch_data)" \
 ${ENDPOINT_BASE_URL}/saml-settings


# get setting
curl -s \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request GET \
  ${ENDPOINT_BASE_URL}/saml-settings