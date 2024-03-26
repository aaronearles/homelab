variable "pm_api_url" {
  type = string
}

variable "pm_api_token_id" {
  type = string
}

variable "pm_api_token_secret" {
  type = string
  sensitive = true
}

# variable "pm_user" {
#   type = string
# }

# variable "pm_password" {
#   type = string
# }

terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.pm_api_url
  pm_tls_insecure = true
  pm_api_token_id = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  # pm_user = var.pm_user
  # pm_password = var.pm_password
  # pm_log_enable = true
  # pm_log_file = "terraform-plugin-proxmox.log"
  # pm_log_levels = {
  #   _default = "debug"
  #   _capturelog = ""
  # }
}