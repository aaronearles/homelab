pm_api_url = "https://pve.sample.internal:8006/api2/json"
pm_api_token_id = "terraform@pve!sampletoken"
pm_api_token_secret = "12345678-abcd-4321-aaaa-123456789ab"
target_node = "pve"

vm_count = 1
start_id = 110
vm_hostname_pfx = "vm"
cloudinit_template_name = "debian-12-cloudinit-template"
ciuser = "sampleuser"
cipassword = "superSecr3t"
sshkeys = "ssh-rsa abcdefg..."