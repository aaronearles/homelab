
variable "target_node" {
    type = string
    description = "Required The name of the Proxmox Node on which to place the VM."
}

variable "lxc_count" {
  type = string 
  description = "Number of containers to deploy"
  default = 1
}

variable "id_start" {
  type = string 
  description = "VM/CT ID Number to start from"
  # default = 100
}

variable "lxc_list" {
  type = list(any)
  description = "List of server numbers ([01,02,03]) -- Define in terraform.tfvars"
}

variable "ostemplate" {
  type = string
  description = "Path to CT Template to clone"
}

variable "lxc_disksize" {
  type = string
  description = "Disk size for container. Such as '8G'"
}

variable "lxc_cores" {
  type = string
  description = "Number of CPU cores to allocate to container. Such as '1'"
}

variable "lxc_memsize" {
  type = string
  description = "Memory size for container. Such as '512`"
}

variable "lxc_hostname_pfx" {
  type = string
  description = "Hostname prefix of container(s)."
}

variable "lxc_password" {
  type = string
  description = "Password of container."
}