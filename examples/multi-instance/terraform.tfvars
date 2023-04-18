#OOB management
ftd_cisco_product_version = "cisco-ftdv-7-0-0-94"
project_id                = "terraform-demo-370415"
region                    = "us-west1"
vm_zones                  = ["us-west1-a", "us-west1-a"]
vm_machine_type           = "c2-standard-4"
vm_instance_labels = {
  firewall    = "ftd"
  environment = "dev"
}
ftd_hostname      = "cisco-ftd"
fmc_hostname      = "cisco-fmc"
admin_ssh_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCII2+Zvw/Var0aEo7B5FMGSmLSByanSeoNyp15ztOl7hsvL7c52kPnF+O288cBTDSJCTHJ3gGp18h0daXlhV8ab6gsQFP+HZtuH60+93Pt+IFMzRq4fT5pY2wYLXQ1Cahkj6rZlrjHGRwDr0mi42TR5i9QiOvWtNAUH0L7RNywvntyWjU2l+bJ/SKJ1rGK1GsNUvTJmk9+vE/JXPfrBqHe3yTrR4vGUa8QRx+x3hiZ32WPvCBKIdKMSdO/hYIs08m/npV1MIQJJZq9ZcCFkFxFGyJ1q4mdoXCSby7SHuqqxzrEEIYSQWixOcDdsNR57RufgjWdM9KwcVODTYaiDbf admin@starship.matrix.com"
admin_password    = "C8Npp2E61Az@6z3L"
enable_password   = "C8Npp2E61Az@6z3L"
ftd_num_instances = 2
# nic0 is the management interface
networks = [
  {
    name         = "vpc-mgmt"
    cidr         = "10.10.10.0/24"
    appliance_ip = ["10.10.10.10", "10.10.10.9"]
    external_ip  = true
  },

  {
    name         = "vpc-outside"
    cidr         = "10.10.11.0/24"
    appliance_ip = ["10.10.11.10", "10.10.11.9"]
    external_ip  = true
  },
  {
    name         = "vpc-inside"
    cidr         = "10.10.12.0/24"
    appliance_ip = ["10.10.12.10", "10.10.12.9"]
    external_ip  = false
  },
  {
    name         = "vpc-dmz"
    cidr         = "10.10.13.0/24"
    appliance_ip = ["10.10.13.10", "10.10.13.9"]
    external_ip  = false
  }
]
appliance_ips_fmc = ["10.10.0.20"]

mgmt_network    = "vpc-mgmt"
inside_network  = "vpc-inside"
outside_network = "vpc-outside"
dmz_network     = "vpc-dmz"
