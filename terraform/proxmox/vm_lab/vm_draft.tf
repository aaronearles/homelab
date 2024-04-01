resource "proxmox_vm_qemu" "vm" {
  count = var.instance_count
  # name        = "VM-name"
  vmid     = count.index + var.id_start
  name     = "${var.hostname_pfx}-${count.index + var.id_start}" //count. ${count.index + 1} if starting at 1
  vm_state = var.vm_state                                        //requires version = "3.0.1-rc1" otherwise use:
  # oncreate      = true //start vm upon creation? deprecated in 3.0.1-rc1
  # name        = "${var.hostname_pfx}-${format("%04d", each.value)}"
  target_node = var.target_node
  # iso         = "ISO file name"

  ### or for a Clone VM operation
  clone      = var.clone_source
  full_clone = false
  scsihw     = "virtio-scsi-single"
  boot       = "order=scsi0;net0"
  disks {
    scsi {
      scsi0 {
        disk {
          backup             = false
          cache              = "none"
          discard            = true
          emulatessd         = true
          iothread           = true
          mbps_r_burst       = 0.0
          mbps_r_concurrent  = 0.0
          mbps_wr_burst      = 0.0
          mbps_wr_concurrent = 0.0
          replicate          = true
          size               = 32
          storage            = "local-lvm"
        }
      }
    }
  }

  ### or for a PXE boot VM operation
  # pxe         = true
  # boot        = "scsi0;net0"
  # agent       = 0

  ### SPECS ###
  memory  = var.memory
  sockets = var.sockets
  cores   = var.cores
  vcpus   = var.vcpus

  os_type = var.os_type
  agent   = var.agent

  network {
    model    = "e1000"
    bridge   = "vmbr0"
    tag      = var.vlan_tag
    firewall = false
  }

}

################### ANSIBLE ######################

# This resource will destroy (potentially immediately) after null_resource.next
resource "null_resource" "previous" {}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [proxmox_vm_qemu.vm]

  create_duration = "10s"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_10_seconds]
}

resource "ansible_group" "lab" {
  name     = "lab"
  #   variables = {
  #     hello = "from group!"
  #   }
}

resource "ansible_host" "labhost" {
  count = var.instance_count
#   name  = "${var.hostname_pfx}-${count.index + var.id_start}" //adds hostname, need IP instead
    name   = proxmox_vm_qemu.vm[count.index].ssh_host
  groups = ["lab"]

  #   variables = {
  #     greetings   = "from host!"
  #     some        = "variable"
  #     yaml_hello  = local.decoded_vault_yaml.hello
  #     yaml_number = local.decoded_vault_yaml.a_number

  # using jsonencode() here is needed to stringify 
  # a list that looks like: [ element_1, element_2, ..., element_N ]
  # yaml_list = jsonencode(local.decoded_vault_yaml.a_list)
  #   }
  depends_on = [time_sleep.wait_10_seconds]
}