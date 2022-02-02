#!/bin/bash

set -e
set -o pipefail

# Setting RUNNER_UNIQ_LABEL will delete other runners with this label.
# This can be used to remove registered runners that are offline due to e.g. an unclean shutdown
if test -n "$RUNNER_UNIQ_LABEL"; then
    for runner in $(curl -sH "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${GITHUB_REPO}/actions/runners | jq -r ".runners | .[]? | select(.labels[].name == \"${RUNNER_UNIQ_LABEL}\").id"); do
        echo "Deleting existing runner with label $RUNNER_UNIQ_LABEL: $runner"
        curl -sX DELETE -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${GITHUB_REPO}/actions/runners/$runner
    done
fi

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
