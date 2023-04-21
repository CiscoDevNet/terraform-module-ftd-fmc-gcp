output "networks_list" {
  value       = module.networking.networks_list
  description = "list of networks"
}

output "ftd_vm_external_ips" {
  value       = module.vm.ftd_external_ips
  description = "external ips for vm"
}
output "networks_map" {
  value       = module.networking.networks_map
  description = "map of networks"
}

output "FMC_Public_IP" {
  value       = module.vm.fmc_external_ips
  description = "Public IP of FMC"
}
output "FTD_Public_IP" {
  value       = module.vm.ftd_external_ips
  description = "Public IP of FMC"
}
