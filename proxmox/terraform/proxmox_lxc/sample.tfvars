pm_api_url = "https://pve.sample.internal:8006/api2/json"
pm_api_token_id = "terraform@pve!sampletoken"
pm_api_token_secret = "12345678-abcd-4321-aaaa-123456789ab"
target_node = "pve"

id_start = 400
lxc_count = 1
lxc_list          = [401,402]
ostemplate = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.zst"
# ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
lxc_disksize = "8G"
lxc_cores    = 1
lxc_memsize  = 512
lxc_hostname_pfx = "lxc-basic"
lxc_password = "superSecr3t"
