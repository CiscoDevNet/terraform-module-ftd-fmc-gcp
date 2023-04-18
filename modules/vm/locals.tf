###############
# Locals
###############
locals {
  #num_zones = length(data.google_compute_zones.available.names)
  #zone = var.zone != null && var.zone != "" ? var.zone : data.google_compute_zones.available.names[count.index % local.num_zones]

  # VM IPs
  ftd_vm_ips = [for x in google_compute_instance.ftd : x.network_interface.0.access_config.0.nat_ip]
  fmc_vm_ips = try([google_compute_instance.fmc[*].network_interface.0.access_config.0.nat_ip], [])

  # compute image and startup script are used for debugging LB with an image such as debian-10.
  fmc_compute_image = var.fmc_compute_image == "" ? data.google_compute_image.fmc.self_link : var.fmc_compute_image
  # fmc_startup_script = var.fmc_startup_script == "" ? data.template_file.fmc_startup_script.rendered : var.fmc_startup_script

}
