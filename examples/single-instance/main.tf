###############
# Locals
###############
locals {
  ha_enabled = var.ftd_num_instances > 1 ? true : false
}
#############################################
# Enable required services on the project
#############################################
resource "google_project_service" "service" {
  for_each = toset(var.project_services)
  project  = var.project_id

  service = each.key

  # Do not disable the service on destroy. This may be a shared project, and
  # we might not "own" the services we enable.
  disable_on_destroy = false
}

#############################################
# Service Account for cisco appliance vm
#############################################
module "service_accounts" {
  source          = "../../modules/service_accounts"
  sa_account_id   = "cisco-ftd-sa"
  sa_display_name = "Cisco FTD Service Account"
  sa_description  = "Terraform-managed service account"
}

###############
# VCP networks
###############
module "networking" {
  source           = "../../modules/networking"
  project_id       = var.project_id
  region           = var.region
  networks         = var.networks
  inside_network   = var.inside_network
  mgmt_network     = var.mgmt_network
  outside_network  = var.outside_network
  dmz_network      = var.dmz_network
  diag_network     = var.diag_network
  custom_route_tag = var.custom_route_tag
  service_account  = module.service_accounts.email
}


###############
# Appliance VM(s)
###############

module "vm" {
  source = "../../modules/vm"

  networks_list        = module.networking.networks_list
  mgmt_network         = var.mgmt_network
  project_id           = var.project_id
  region               = var.region
  ftd_num_instances    = var.ftd_num_instances
  ftd_hostname         = var.ftd_hostname
  fmc_hostname         = var.fmc_hostname
  vm_zones             = var.vm_zones
  custom_route_tag     = var.custom_route_tag
  vm_instance_labels   = var.vm_instance_labels
  vm_instance_tags     = var.vm_instance_tags
  service_account      = module.service_accounts.email
  admin_ssh_pub_key    = var.admin_ssh_pub_key
  ftd_day_0_config     = var.ftd_day_0_config
  fmc_day_0_config     = var.fmc_day_0_config
  admin_password       = var.admin_password
  appliance_ips_fmc    = var.appliance_ips_fmc
  subnet_self_link_fmc = module.networking.subnet_self_link_fmc

  depends_on = [
    module.networking
  ]
}

##############################
# External and Internal LB
##############################

module "lb-1" {
  count  = local.ha_enabled ? 1 : 0
  source = "../../modules/load_balancer"

  networks_map        = module.networking.networks_map
  project_id          = var.project_id
  region              = var.region
  vm_zones            = var.vm_zones
  service_port        = var.service_port
  use_internal_lb     = var.use_internal_lb
  allow_global_access = var.allow_global_access
  inside_network      = var.inside_network
  mgmt_network        = var.mgmt_network
  num_instances       = var.num_instances
  named_ports         = var.named_ports
  instance_ids        = module.vm.instance_ids
}
