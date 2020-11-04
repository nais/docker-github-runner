#!/bin/sh

if test -z "${RUNNER_TOKEN}"; then
    payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" https://api.github.com/repos/${GITHUB_REPO}/actions/runners/registration-token)
    RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)
fi

/opt/runner/config.sh \
    --name ${HOSTNAME} \
    --labels platform-apps-runner,${NAIS_CLUSTER_NAME} \
    --token ${RUNNER_TOKEN} \
    --url https://github.com/${GITHUB_REPO} \
    --work $HOME/_work \
    --unattended \
    --replace

while true; do
    /opt/runner/run.sh
    echo Runner exit: Restarting in 1m...
    sleep 60
done
