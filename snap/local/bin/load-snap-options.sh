#!/bin/bash -e

export SERVER_ADDRESS=$(snapctl get server-address)
export TOPIC_PREFIX=$(snapctl get topic-prefix)

exec "$@"