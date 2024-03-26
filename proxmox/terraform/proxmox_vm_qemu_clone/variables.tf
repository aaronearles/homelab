
variable "vm_count" {
    type = string
    default = 1
}

variable "start_id" {
    type = string
    description = "VM/CT ID Number to start from"
}

variable "vm_hostname_pfx" {
  type = string
  description = "Hostname prefix of VM(s)."
}

variable "cloudinit_template_name" {
    type = string 
}

variable "target_node" {
    type = string
    description = "Required The name of the Proxmox Node on which to place the VM."
}

variable "sshkeys" {
  type = string 
  description = "Newline delimited list of SSH public keys to add to authorized keys file for the cloud-init user."
  sensitive = true
  default = ""
}

variable "ciuser" {
  type = string
  description = "Override the default cloud-init user for provisioning."
}

variable "cipassword" {
  type = string
  description = "Override the default cloud-init user's password. Sensitive."
  sensitive = true
}