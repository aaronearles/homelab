#!/bin/bash
sudo docker run -d --restart=unless-stopped -p 3001:3001 -v /docker/uptime-kuma:/app/data --name uptime-kuma louislam/uptime-kuma:1