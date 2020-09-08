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

remove() {
    /opt/runner/config.sh remove --unattended --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./run.sh "$*" &

wait $!
