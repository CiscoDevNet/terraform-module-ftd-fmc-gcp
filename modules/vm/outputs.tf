output "ftd_external_ips" {
  value       = local.ftd_vm_ips
  description = "FTD external ips for VPC networks"
}

output "fmc_external_ips" {
  value       = local.fmc_vm_ips
  description = "FMC external ips for VPC networks"
}

output "ftd_instance_ids" {
  value       = google_compute_instance.ftd[*].id
  description = "a list of instance ids"
}
output "fmc_instance_ids" {
  value       = google_compute_instance.fmc[*].id
  description = "a list of instance ids"
}
