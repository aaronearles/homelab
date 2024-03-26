#!/bin/bash
#MINECRAFT-BEDROCK-SERVER
 
 docker run -dit --name minecraft-bedrock-server --restart unless-stopped \
    -p 19132:19132/tcp \
    -p 19132:19132/udp \
    -p 25575:25575/tcp \
    -p 25575:25575/udp \
    -v /docker/bedrock-server/worlds:/bedrock-server/worlds \
    -v /docker/bedrock-server/whitelist.json:/bedrock-server/whitelist.json \
    -v /docker/bedrock-server/server.properties:/bedrock-server/server.properties \
    marctv/minecraft-bedrock-server:latest
