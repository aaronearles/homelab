# Notes

## Re-architecture Planning
Considering consolidating services to a set of Prod and Lab docker hosts and consolidating persistent CT/VMs in Proxmox to very few.

Does this model scale to multiple nodes and support future K8S migration?

```
rPi3, rPi5
    Should config_mgmt, and/or monitoring run external to PVE? What about DNS?

nas
    Keep simple, storage/backups only.

pve-1
    util1/(ansible, terraform, gha runner agent?) should these be on rPi instead? internal-ca
    prod-docker1
        portainer
        dns/bind
        .sql/mariadb
        .psql/postgres
        .ansible
        .log/graph/prometheus/loki/influxdb/grafana
        vpn/tailscale/net-bird/zerotier
        .rproxy/traefik
        monitoring/gatus/uptime-kuma
        dashboard/homepage
        minecraft
        playback/jellyfin

    dmz-docker1
        blog
        media_services -- Move these to a separate VM?
            .vpn/gluetun
            downloads/qbt
            indexer/prowl
            discovery/jellyseer
            movies/radar
            series/sonar

    lab-docker1
        portainer
        dns/bind
        .sql/mariadb
        .psql/postgres

    win11-desktop
    ubuntu-desktop

.pve-2
    HA for critical service
    Kubernetes? Or should k8s be separate?

(linode)
    watchman
        external-monitoring/uptime-kuma/.gatus

```

Create a docker server template / configure as code for repeatable environments or lab re-deployment.

Try to standardize on single OS, Ubuntu vs Debian. Maybe all primary/Docker hosts are Ubuntu and "appliances" are Debian?

Internal container registry?