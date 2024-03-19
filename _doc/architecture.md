# Re-architecture Planning

### NEEDS REVIEW:
### How will internal DNS server work cross-vlan with unifi in play?

UDM intercepts all DNS requests. Need to determine how to configure UDM to ignore local DNS requests, assign local DNS server (172.20.100.3, .4) in DHCP, and continue to act as a forwarder for internet requests.

[1] Settings -> Networks -> Default -> DHCP Service Management -> Show Options -> DNS Server: by default, "Auto" is checked. If I uncheck it, I can enter up to 4 DNS servers.

[2] Internet -> Primary (WAN 1) -> DNS Server: by default "Auto" is checked. If I uncheck "Auto", I can enter up to 2 DNS servers.

Continue to use Unifi for DNS and add forwarder for earles.internal and earles.io that points to Bind?

---

### Overview
Considering consolidating services to a set of Prod and Lab docker hosts and consolidating persistent CT/VMs in Proxmox to very few.

Does this model scale to multiple nodes and support future K8S migration?

### Notes

Create a docker server template / configure as code for repeatable environments or lab re-deployment.

Try to standardize on single OS, Ubuntu vs Debian. Maybe all primary/Docker hosts are Ubuntu and "appliances" are Debian?

Internal container registry

## Current State

### Current Physical Machines
```
hostname    model       role

util        rPi5        Docker: DNS/Slave, Rocket, Ansible, Tf, Gatus
pve         TMM         Proxmox Primary
nas         DS215j      Primary Storage/Backups, Future Backups
```

### Current VM List
```
util
    bare-metal:(?)
        bind
        rocket (gh actions)
        gatus
        ansible
        terraform

pve
    util2 (lxc)
        internal-ca
        nmap, misc tools

    prod-docker1 (vm)
        portainer
        rproxy/traefik
        vpn/tailscale/net-bird/zerotier
        dashboard/homepage
        minecraft
        playback/jellyfin
        .sql/mariadb
        .psql/postgres
        .log/graph/prometheus/loki/influxdb/grafana


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

nas
    Keep simple, storage/backups only.
```


## Future State

### Planned Physical Machines
```
hostname    model       role

dns1        rPi3        DNS/Master
dns2        rPi3        DNS/Slave
k8s1        rPi5        Kubernetes A
k8s2        rPi5        Kubernetes B
k8s3        rPi5        Kubernetes C
pve1        TMM         Proxmox Primary
pve2        TMM         Proxmox Secondary
nas1        DS215j      Primary Storage/Backups, Future Backups
nas2        TBD         Future Primary Storage
```

### Detailed VM/Container Plan
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