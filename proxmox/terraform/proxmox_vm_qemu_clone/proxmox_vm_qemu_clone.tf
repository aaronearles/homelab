########## VM CONFIGURATION ##########

resource "proxmox_vm_qemu" "vm" {
  count        = var.vm_count
  name         = "${var.vm_hostname_pfx}-${count.index + var.start_id}"
  vmid         = "${count.index + var.start_id}"
  target_node  = var.target_node
  clone        = var.cloudinit_template_name
  agent        = 1
  os_type      = "cloud-init"
  cores        = 1
  sockets      = 1
  cpu          = "host"
  memory       = 1024
  scsihw       = "virtio-scsi-pci"
  bootdisk     = "scsi0"
  qemu_os      = "l26"

  disk {
    slot       = 0
    size       = "32G"
    type       = "scsi"
    ssd        = 1
    storage    = "local-lvm"
  }

  network {
    model      = "virtio"
    bridge     = "vmbr0"
  }
  
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # ipconfig0    = "ip=192.168.1.2${count.index + 1}/24,gw=192.168.1.1"
  ipconfig0    = "dhcp"
  # nameserver   = "172.20.100.1"

  ciuser       = var.ciuser
  cipassword   = var.cipassword
  
  sshkeys    = <<EOF
  ${var.sshkeys}
  EOF

}
