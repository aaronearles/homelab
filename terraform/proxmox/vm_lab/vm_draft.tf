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

resource "ansible_host" "labhost" {
  count = var.instance_count
  name  = "${var.hostname_pfx}-${count.index + var.id_start}"
  #   name   = proxmox_vm_qemu.vm.[this-isnt-right].name
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
}

resource "ansible_group" "lab" {
  name     = "lab"
  children = ansible_host.labhost
  #   variables = {
  #     hello = "from group!"
  #   }
}