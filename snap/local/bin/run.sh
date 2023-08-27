#!/bin/bash -ex

export SERVER_ADDRESS=$(snapctl get server-address)
export TOPIC_PREFIX=$(snapctl get topic-prefix)
ARGS=$(snapctl get args)

$SNAP/bin/chip-bridge-app $ARGS