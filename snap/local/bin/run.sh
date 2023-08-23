#!/bin/bash -ex

export SERVER_ADDRESS=$(snapctl get server-address)
export TOPIC_PREFIX=$(snapctl get topic-prefix)

$SNAP/bin/chip-bridge-app