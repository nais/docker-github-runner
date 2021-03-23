#!/bin/sh

if test -z "$ENVOY_ADMIN_API"; then
    exec /opt/start-runner.sh
else
    echo Starting runner with scuttle
    exec /opt/scuttle /opt/start-runner.sh
fi
