variable "project_id" {
  type        = string
  description = "The project ID to host the network in"
}
variable "region" {
  type        = string
  description = "The region"
}

variable "networks_list" {
  type        = list(object({ name = string, network_self_link = string, subnet_self_link = string, subnet_cidr = string, appliance_ip = list(string), external_ip = bool, routes = list(string) }))
  description = "network links in a map(network_name)"
}

variable "mgmt_network" {
  type        = string
  description = "management network name"
  default     = ""
}
variable "ftd_num_instances" {
  description = "Number of FTD instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 2
  # validation {
  #   condition     = var.num_instances <= 2
  #   error_message = "The num_instances value must be less than or equal to 2."
  # }
}
variable "fmc_num_instances" {
  description = "Number of FMC instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
  # validation {
  #   condition     = var.num_instances <= 2
  #   error_message = "The num_instances value must be less than or equal to 2."
  # }
}

variable "vm_zones" {
  type        = list(string)
  description = "The zones"
}


variable "custom_route_tag" {
  type        = string
  description = "tag for custom route"
}


variable "ftd_vm_machine_type" {
  type        = string
  description = "FTD machine type for appliance"
  default     = "e2-standard-4"
}

variable "fmc_vm_machine_type" {
  type        = string
  description = "FMC machine type for appliance"
  default     = "e2-standard-4"
}

variable "vm_instance_labels" {
  type    = map(string)
  default = {}

  description = "Labels to apply to the vm instances."
}


variable "vm_instance_tags" {
  type    = list(string)
  default = []

  description = "Additional tags to apply to the instances, please note the service account is used as much as possible as best practice"
}

variable "ftd_cisco_product_version" {
  type        = string
  description = "ftd cisco product version"
  default     = "cisco-ftdv-7-0-0-94"
}

variable "fmc_cisco_product_version" {
  type        = string
  description = "fmc_cisco product version"
  default     = "cisco-asav-9-16-1-28"
}

variable "fmc_compute_image" {
  type        = string
  description = "FMC vm image"
  default     = "cisco-fmcv-7-3-0-69"
}

variable "admin_ssh_pub_key" {
  type        = string
  description = "ssh public key for admin"
}
variable "ftd_day_0_config" {
  type        = string
  description = "ftd zero day configuration"
  default     = ""
}

variable "fmc_day_0_config" {
  type        = string
  description = "fmc zero day configuration"
  default     = ""
}

# variable "fmc_startup_script" {
#   type        = string
#   description = "startup script"
# }

variable "service_account" {
  description = "The email address of the service account which will be assigned to the compute instances."
  type        = string
}


variable "admin_password" {
  type        = string
  description = "password for ftd admin"
  sensitive   = true
}

variable "ftd_hostname" {
  default     = "ftd"
  description = "FTD hostname"
}

variable "fmc_hostname" {
  default     = "fmc"
  description = "FMC hostname"
}
variable "subnet_self_link_fmc" {
  description = "subnet self link of management network"
}
variable "appliance_ips_fmc" {
  type        = list(string)
  description = "appliance IPs of management network"
}
