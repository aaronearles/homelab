
variable "target_node" {
  type        = string
  description = "Required The name of the Proxmox Node on which to place the VM."
  default     = "pve"
}

variable "instance_count" {
  type        = string
  description = "Number of instances to deploy"
  # default     = 1
}

variable "id_start" {
  type        = string
  description = "VM/CT ID Number to start from"
  # default     = 400
}

# variable "instance_list" {
#   type = list(any)
#   description = "List of server numbers ([01,02,03]) -- Define in terraform.tfvars"
#   default = "[01,02,03]"
# }

variable "clone_source" {
  type = string
  description = "VMID# of container template to clone" #"801"
}

variable "hostname_pfx" {
  type        = string
  description = "Hostname prefix of container(s)."
  default     = "vm-"
}

variable "admin_password" {
  type        = string
  description = "Password for container"
}