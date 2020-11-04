#!/bin/sh

echo Unregister runner...

if test -z "${RUNNER_TOKEN}"; then
    payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${GITHUB_REPO}/actions/runners/registration-token)
    RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)
fi

/opt/runner/config.sh remove --unattended --token "${RUNNER_TOKEN}"
