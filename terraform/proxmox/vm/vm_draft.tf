resource "proxmox_vm_qemu" "vm" {
  count = var.instance_count
  # name        = "VM-name"
  name    = "${var.hostname_pfx}-${count.index + var.id_start}" //count. ${count.index + 1} if starting at 1
  # name     = "${var.hostname_pfx}-${format("%04d", each.value)}"
  target_node = var.target_node
  # iso         = "ISO file name"

  ### or for a Clone VM operation
  clone = "801"

  ### or for a PXE boot VM operation
  # pxe = true
  # boot = "scsi0;net0"
  # agent = 0
}


# ########## LXC CONFIGURATION ##########

# resource "proxmox_lxc" "basic" {
#   count = var.lxc_count
#   # for_each            = { for i in var.lxc_list : "key_${i}" => i }
#   target_node = var.target_node
#   hostname    = "${var.lxc_hostname_pfx}-${count.index + var.id_start}" //count. ${count.index + 1} if starting at 1
#   # hostname     = "${var.lxc_hostname_pfx}-${format("%04d", each.value)}"
#   vmid         = count.index + var.id_start
#   ostemplate   = var.ostemplate
#   password     = var.lxc_password
#   unprivileged = true
#   start        = true
#   cores        = var.lxc_cores
#   memory       = var.lxc_memsize

#   # ssh_public_keys = <<-EOT
#   #   ssh-rsa abcd1234
#   # EOT

#   // Terraform will crash without rootfs defined
#   rootfs {
#     storage = "local-lvm"
#     size    = var.lxc_disksize
#   }

#   network {
#     name   = "eth0"
#     bridge = "vmbr0"
#     ip     = "dhcp"
#   }

# }
