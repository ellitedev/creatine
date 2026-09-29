#!/bin/sh
# start a local test server for the pack

podman run -i --pull=always \
    -e TYPE=NEOFORGE \
    -e EULA=true \
    -e VERSION=1.21.1 \
    -e NEOFORGE_VERSION=21.1.252 \
    -e "PACKWIZ_URL=http://host.containers.internal:8080/pack.toml" \
    -p 25565:25565 \
    "$@" \
    itzg/minecraft-server