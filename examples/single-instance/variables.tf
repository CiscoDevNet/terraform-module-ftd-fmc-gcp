variable "project_id" {
  description = "The project ID to host the network in"
}
variable "region" {
  description = "The region"
}

variable "networks" {
  type        = list(object({ name = string, cidr = string, appliance_ip = list(string), external_ip = bool }))
  description = "a list of VPC"
  default     = []
}

variable "vm_zones" {
  type        = list(string)
  description = "The zones"
}

variable "vm_machine_type" {
  description = "machine type for appliance"
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
  description = "cisco product version"
  default     = "cisco-ftdv-7-0-0-94"
}
variable "ftd_num_instances" {
  description = "Number of instances to create. This value is ignored if static_ips is provided."
  type        = number
  default     = 1
}
variable "ftd_hostname" {
  default     = "ftd"
  description = "FTD hostname"
}
variable "fmc_hostname" {
  default     = "fmc"
  description = "FMC hostname"
}

variable "admin_password" {
  type        = string
  description = "password for admin"
  sensitive   = true
}
variable "admin_ssh_pub_key" {
  description = "ssh public key for admin"
}
variable "ftd_day_0_config" {
  type        = string
  description = "Render a startup script with a template."
  default     = "startup_file.json"
}
variable "fmc_day_0_config" {
  type        = string
  description = "Render a startup script for fmc with a template."
  default     = "fmc.txt"
}
variable "mgmt_network" {
  type        = string
  description = "management network name"
  default     = ""
}

variable "inside_network" {
  type        = string
  description = "inside network name"
  default     = ""
}
variable "outside_network" {
  type        = string
  description = "outside network name"
  default     = ""
}

variable "dmz_network" {
  type        = string
  description = "dmz network name"
  default     = ""
}

variable "diag_network" {
  type        = string
  description = "diag network name"
  default     = ""
}

variable "enable_password" {
  type        = string
  description = "enable password for ASA zero day config"
}

variable "project_services" {
  type = list(string)

  default = [
    "compute.googleapis.com",
    "iam.googleapis.com",
  ]

  description = "List of services to enable on the project where Vault will run. These services are required in order for this Vault setup to function."
}

variable "custom_route_tag" {
  type        = string
  description = "tag for custom route"
  default     = "cisco-ftd"
}

variable "service_port" {
  type        = number
  description = "service port"
  default     = 80
}

variable "use_internal_lb" {
  type        = bool
  default     = false
  description = "use internal LB or not"
}

variable "allow_global_access" {
  type        = bool
  default     = false
  description = "Internal LB allow global access or not"
}

variable "named_ports" {
  description = "Named name and port. https://cloud.google.com/load-balancing/docs/backend-service#named_ports"
  type = list(object({
    name = string
    port = number
  }))
  default = [
    {
      name = "console"
      port = 22
    },
    {
      name = "https"
      port = 443
    }
  ]
}

variable "appliance_ips_fmc" {
  type        = list(string)
  default     = []
  description = "internal IP addresses for cisco appliance"
}
