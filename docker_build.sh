#!/bin/bash

set -e

IMAGE_NAME="aaronbbrown/pihole-gravity"
docker build -t "$IMAGE_NAME" $(dirname $0)
docker push "$IMAGE_NAME"
