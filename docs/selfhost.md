# Selfhosting

Self hosting a Minecraft server on your own VPS/Dedicated Server/System is very easy! Even easier if you already have [Docker](https://www.docker.com/get-started/) set up.

This guide will assume you have some basic knowledge of docker.

The _recommended_ amount of RAM available to the server is `8GB`. You probably _can_ run it with less, but that's not recommended.

I would also _heavily_ suggest you read this [getting started article](https://docker-minecraft-server.readthedocs.io/en/latest/) by itzg.

## Simple Docker run commands

Below are some barebones docker run commands to help get you set up quickly. I would personally suggest going with a Docker Compose stack instead. Since that's easier to manage and keep track of. Refer to the [getting started article](https://docker-minecraft-server.readthedocs.io/en/latest/#using-docker-compose) to learn more.

Make sure to replace `/path/on/host` with an actual path on your system. `24454` is the port that Simple Voice Chat uses. If you change it, I recommend you update it in the configuration file for that mod too after your server is set up.

### Using Packwiz

```shell
docker run -d -it --pull=always \
    -v /path/on/host:/data -e TYPE=NEOFORGE \
    -e VERSION=1.21.1 \
    -e NEOFORGE_VERSION=21.1.252 \
    -e "PACKWIZ_URL=https://creatinepack.girlfag.club/pack.toml" \
    -e EULA=TRUE \
    -e MEMORY=8G \
    -e JVM_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -XX:+UseStringDeduplication" \
    -p 25565:25565 \
    -p 24454:24454/udp \
    itzg/minecraft-server:java25
```

### Using Modrinth

```shell
docker run -d -it --pull=always \
    -v /path/on/host:/data -e TYPE=MODRINTH \
    -e "MODRINTH_MODPACK=https://modrinth.com/modpack/creatinepack" \
    -e EULA=TRUE \
    -e MEMORY=8G \
    -e JVM_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -XX:+UseStringDeduplication" \
    -p 25565:25565 \
    -p 24454:24454/udp \
    itzg/minecraft-server:java25
```

## Docker Compose

I've yet to make one myself, but you can try your luck with a simple tool like this one: [https://setupmc.com/java-server/](https://setupmc.com/java-server/)
