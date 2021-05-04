#!/bin/sh

payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${GITHUB_REPO}/actions/runners/registration-token)
RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)
/opt/runner/config.sh \
    --name ${HOSTNAME} \
    --labels ${RUNNER_LABELS} \
    --token ${RUNNER_TOKEN} \
    --url https://github.com/${GITHUB_REPO} \
    --work $HOME/_work \
    --unattended \
    --replace
exec /opt/runner/bin/runsvc.sh
