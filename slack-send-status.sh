#!/bin/sh

COLOR=$1
MESSAGE=$2

PAYLOAD='{"username": "Nais-platform-apps runner", "attachments": [ { "fallback": '\"${MESSAGE}\"', "color": '\"${COLOR}\"', "title": '\"\"', "text": '\"${MESSAGE}\"' } ] }'

curl -H 'Content-type: application/json' -d "${PAYLOAD}" "${SLACK_WEBHOOK}"
