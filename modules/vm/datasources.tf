###############
# Data Sources
###############
data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
  status  = "UP"
}

# e.g. https://www.googleapis.com/compute/v1/projects/cisco-public/global/images/cisco-ftdv-7-0-0-94
data "google_compute_image" "ftd" {
  project = "cisco-public"
  name    = var.ftd_cisco_product_version
}

data "template_file" "ftd_startup_script" {
  count    = var.ftd_num_instances
  template = file("${path.module}/templates/${var.ftd_day_0_config}")
  vars = {
    admin_password = var.admin_password
    fmc_ip         = "10.10.0.20"
    reg_key        = "cisco"
    fmc_nat_id     = ""
    hostname       = "${var.ftd_hostname}%{if var.ftd_num_instances > 0}-${count.index + 1}%{endif}"
  }
}

data "google_compute_image" "fmc" {
  project = "cisco-public"
  name    = var.fmc_cisco_product_version
}

data "template_file" "fmc_startup_script" {
  template = file("${path.module}/templates/${var.fmc_day_0_config}")
  vars = {
    admin_password = var.admin_password
    //hostname       = "${var.hostname}%{if var.num_instances > 0}-${count.index + 1}%{endif}"
    hostname = "cisco-fmcv"
  }
}
