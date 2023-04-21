#OOB management
cisco_product_version = "cisco-ftdv-7-0-0-94"
project_id            = ""
region                = "us-west1"
vm_zones              = ["us-west1-a"]
vm_machine_type       = "c2-standard-8"
vm_instance_labels = {
  firewall    = "ftd"
  environment = "dev"
}
hostname          = "cisco-ftd"
fmc_hostname      = "cisco-fmc"
day_0_config      = "startup_file.json"
admin_ssh_pub_key = ""
admin_password    = "C8Npp2E61Az@6z3L"
enable_password   = "C8Npp2E61Az@6z3L"
num_instances     = 1
# nic0 is the management interface
networks = [
  {
    name         = "vpc-mgmt"
    cidr         = "10.10.0.0/24"
    appliance_ip = ["10.10.0.10"]
    external_ip  = true
  },
  # {
  #   name         = "vpc-diag"
  #   cidr         = "10.10.1.0/24"
  #   appliance_ip = ["10.10.1.10"]
  #   external_ip  = false
  # },
  {
    name         = "vpc-outside"
    cidr         = "10.10.2.0/24"
    appliance_ip = ["10.10.2.10"]
    external_ip  = true
  },
  {
    name         = "vpc-inside"
    cidr         = "10.10.3.0/24"
    appliance_ip = ["10.10.3.10"]
    external_ip  = false
  },
  {
    name         = "vpc-dmz"
    cidr         = "10.10.4.0/24"
    appliance_ip = ["10.10.4.10"]
    external_ip  = false
  }
]

appliance_ips_fmc = ["10.10.0.20"]
mgmt_network      = "vpc-mgmt"
inside_network    = "vpc-inside"
outside_network   = "vpc-outside"
dmz_network       = "vpc-dmz"
//diag_network    = "vpc-diag"
