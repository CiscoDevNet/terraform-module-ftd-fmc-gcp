#############################################
# Instances
#############################################
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}
resource "google_compute_instance" "ftd" {
  provider                  = google
  count                     = var.ftd_num_instances
  project                   = var.project_id
  name                      = "${var.ftd_hostname}-${count.index + 1}-${random_string.suffix.result}"
  zone                      = var.vm_zones[count.index]
  machine_type              = var.ftd_vm_machine_type
  can_ip_forward            = true
  allow_stopping_for_update = true
  tags                      = try(var.vm_instance_tags, [])
  labels                    = try(var.vm_instance_labels, {})

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ftd.self_link
    }
  }

  metadata = {
    ssh-keys       = var.admin_ssh_pub_key
    startup-script = data.template_file.ftd_startup_script[count.index].rendered
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  dynamic "network_interface" {
    for_each = var.networks_list
    content {
      subnetwork = network_interface.value.subnet_self_link
      network_ip = network_interface.value.appliance_ip[count.index]
      dynamic "access_config" {
        for_each = network_interface.value.external_ip ? ["external_ip"] : []
        content {
          nat_ip = null
          # nat_ip       = access_config.value.address
          network_tier = "PREMIUM"
        }
      }
    }
  }
}

resource "google_compute_instance" "fmc" {
  count                     = var.fmc_num_instances
  provider                  = google
  project                   = var.project_id # Replace with your project ID in quotes
  name                      = "asa-fmc-${count.index + 1}-${random_string.suffix.result}"
  zone                      = var.vm_zones[count.index]
  machine_type              = var.fmc_vm_machine_type
  can_ip_forward            = true
  allow_stopping_for_update = true
  tags                      = try(var.vm_instance_tags, [])
  labels                    = try(var.vm_instance_labels, {})

  boot_disk {
    initialize_params {
      image = local.fmc_compute_image
    }
  }

  metadata = {
    ssh-keys                 = var.admin_ssh_pub_key
    startup-script           = data.template_file.fmc_startup_script.rendered
    google-monitoring-enable = "0"
    google-logging-enable    = "0"
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = var.subnet_self_link_fmc
    # subnetwork_project = var.network_project_id
    network_ip = var.appliance_ips_fmc[count.index]
    access_config {
      nat_ip       = null
      network_tier = "PREMIUM"
    }
    # dynamic "network_interface" {
    #   for_each = var.networks_list
    #   content {
    #     subnetwork = network_interface.value.subnet_self_link
    #     network_ip = network_interface.value.appliance_ip[count.index]
    #     dynamic "access_config" {
    #       for_each = network_interface.value.external_ip ? ["external_ip"] : []
    #       content {
    #         nat_ip = null
    #         # nat_ip       = access_config.value.address
    #         network_tier = "PREMIUM"
    #       }
    #     }
    #   }
  }
}
