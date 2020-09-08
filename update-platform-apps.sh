#!/usr/bin/env bash

set -e
SOURCE_DIR=$1

mkdir -p /tmp/update-platform-apps.$$
rm -f /tmp/update-platform-apps.$$/*
naiscaper $SOURCE_DIR/base $SOURCE_DIR/clusters/$NAIS_CLUSTER_NAME /tmp/update-platform-apps.$$
helm repo update
bashscaper $NAIS_NAMESPACE "" /tmp/update-platform-apps.$$/*.yaml

rm -rf /tmp/update-platform-apps.$$
