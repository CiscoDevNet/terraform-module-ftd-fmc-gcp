
<!-- BEGIN_TF_DOCS -->

## Overview

This is an example on how to create a mutiple FTDv instances and single FMC with the module. This is a module for Cisco ASAv in GCP.
## Prerequisites

Make sure you have the following:

- Terraform – Learn how to download and set up [here](https://learn.hashicorp.com/terraform/getting-started/install.html).
- gcloud auth application-default login [here](https://cloud.google.com/compute/docs/authentication)

## FTD version supported

* 7.x

## Requirements


| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=v1.3.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.80, <4.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 3.80, <4.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 3.80, <4.0 |

## Prerequisites

Install gcloud and authenticate by running the following command
```bash
gcloud auth application-default login
```

Additionally, Google cloud project credentials can be used following this link:
[Getting started with Terraform on Google Cloud](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform)


## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lb-1"></a> [lb-1](#module\_lb-1) | ../../modules/load_balancer | n/a |
| <a name="module_networking"></a> [networking](#module\_networking) | ../../modules/networking | n/a |
| <a name="module_service_accounts"></a> [service\_accounts](#module\_service\_accounts) | ../../modules/service_accounts | n/a |
| <a name="module_vm"></a> [vm](#module\_vm) | ../../modules/vm | n/a |



## Examples

Examples of how to use these modules can be found in the [examples](examples/) folder.
- [single FTDv instance use case](examples/single-instance/terraform.tfvars.example)


## GCP Resource managed

* New VPC networks, subnets and firewall rules would be created.
* A service account is created and is used as target for firewall rules.
* A single instance or a number of instances would be created depending on use case.

### (Optional) Set up a GCS backend

```bash
cd examples/single-instance
```

Add backend.tf accordingly,

```hcl
terraform {
  backend "gcs" {
    bucket = "<a-unique-bucket-for-terraform-states>"
    prefix = "ftd/single-instance"
  }
}
```

## Customize ssh key pair

```bash
# Generate a ssh key pair with 2048 bits key as 2048 bits is supported by ASA
ssh-keygen -t rsa -b 2048 -f admin-ssh-key
```

Then replace the **admin-ssh-key** public key in the terraform variable file.

## Customize firewall rules

![Firewall rules](images/firewall-rules.png).

* Firewall rules would be created as shown.
* Management network allows TCP port 22 and 8305 while other networks allow all TCP ports by default.
* To customize it, please change [firewall.tf](modules/networking/firewall.tf).

## Customize service account

`account_id` is the GCP service account, it can be customized for different deployment if desired.

A service account is a special type of Google Account that represents a Google Cloud service identity or app rather than an individual user. Like users and groups, service accounts can be assigned IAM roles to grant access to specific resources. Service accounts authenticate with a key rather than a password. Google manages and rotates the service account keys for code running on Google Cloud. We recommend that you use service accounts for server-to-server interactions.

Please don't use the default compute engine service account which has the project editor role by default, obviously too permissive. The template would create a service account.

## Customize routes

[networking/main.tf](modules/networking/main.tf) can be changed. Currently left out for various customization.

## Deploy Using the Terraform CLI

```bash
cd examples/single-instance
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
terraform destroy
```
## Cisco CLI validation

FTD SSH session
```bash
IP_ADDRESS=$(terraform output -json vm_external_ips  | jq -r '.[0][0]')
ssh -i admin-ssh-key admin@$IP_ADDRESS
```
![SSH](images/ssh.png)

### A note on SSH RSA SHA-1

[OpenSSH release 8.8 and up](https://www.openssh.com/txt/release-8.8) disables RSA signatures using the SHA-1 hash algorithm by default.
If you run into an error: `Unable to negotiate with 34.83.229.123 port 22: no matching host key type found. Their offer: ssh-rsa`
Check if the SSH client with `ssh -V` and see if it is 8.8 up, then you can re-enable RSA/SHA1 to allow connection and/or user
authentication via the HostkeyAlgorithms and PubkeyAcceptedAlgorithms.
```bash
~/.ssh/config
Host x.y.z.x
   HostkeyAlgorithms +ssh-rsa
   PubkeyAcceptedAlgorithms +ssh-rsa
```

Alternatively ```ssh -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa  -i admin-ssh-key admin@${IP_ADDRESS}``` works too.


## Source code files naming convention

* locals.tf: local variables
* variables.tf: input variables
* outputs.tf: output variables
* datasource.tf: define data source such as zones, compute images and template.
* network.tf: define VPC networks, custom routes.
* firewall.tf: define firewall rules.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | password for admin | `string` | n/a | yes |
| <a name="input_admin_ssh_pub_key"></a> [admin\_ssh\_pub\_key](#input\_admin\_ssh\_pub\_key) | ssh public key for admin | `any` | n/a | yes |
| <a name="input_allow_global_access"></a> [allow\_global\_access](#input\_allow\_global\_access) | Internal LB allow global access or not | `bool` | `false` | no |
| <a name="input_appliance_ips_fmc"></a> [appliance\_ips\_fmc](#input\_appliance\_ips\_fmc) | internal IP addresses for cisco appliance | `list(string)` | `[]` | no |
| <a name="input_custom_route_tag"></a> [custom\_route\_tag](#input\_custom\_route\_tag) | tag for custom route | `string` | `"cisco-ftd"` | no |
| <a name="input_diag_network"></a> [diag\_network](#input\_diag\_network) | diag network name | `string` | `""` | no |
| <a name="input_dmz_network"></a> [dmz\_network](#input\_dmz\_network) | dmz network name | `string` | `""` | no |
| <a name="input_enable_password"></a> [enable\_password](#input\_enable\_password) | enable password for ASA zero day config | `string` | n/a | yes |
| <a name="input_fmc_day_0_config"></a> [fmc\_day\_0\_config](#input\_fmc\_day\_0\_config) | Render a startup script for fmc with a template. | `string` | `"fmc.txt"` | no |
| <a name="input_fmc_hostname"></a> [fmc\_hostname](#input\_fmc\_hostname) | FMC hostname | `string` | `"fmc"` | no |
| <a name="input_ftd_cisco_product_version"></a> [ftd\_cisco\_product\_version](#input\_ftd\_cisco\_product\_version) | cisco product version | `string` | `"cisco-ftdv-7-0-0-94"` | no |
| <a name="input_ftd_day_0_config"></a> [ftd\_day\_0\_config](#input\_ftd\_day\_0\_config) | Render a startup script with a template. | `string` | `"startup_file.json"` | no |
| <a name="input_ftd_hostname"></a> [ftd\_hostname](#input\_ftd\_hostname) | FTD hostname | `string` | `"ftd"` | no |
| <a name="input_ftd_num_instances"></a> [ftd\_num\_instances](#input\_ftd\_num\_instances) | Number of instances to create. This value is ignored if static\_ips is provided. | `number` | n/a | yes |
| <a name="input_inside_network"></a> [inside\_network](#input\_inside\_network) | inside network name | `string` | `""` | no |
| <a name="input_mgmt_network"></a> [mgmt\_network](#input\_mgmt\_network) | management network name | `string` | `""` | no |
| <a name="input_named_ports"></a> [named\_ports](#input\_named\_ports) | Named name and port. https://cloud.google.com/load-balancing/docs/backend-service#named_ports | <pre>list(object({<br>    name = string<br>    port = number<br>  }))</pre> | <pre>[<br>  {<br>    "name": "console",<br>    "port": 22<br>  },<br>  {<br>    "name": "https",<br>    "port": 443<br>  }<br>]</pre> | no |
| <a name="input_networks"></a> [networks](#input\_networks) | a list of VPC | `list(object({ name = string, cidr = string, appliance_ip = list(string), external_ip = bool }))` | `[]` | no |
| <a name="input_outside_network"></a> [outside\_network](#input\_outside\_network) | outside network name | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to host the network in | `any` | n/a | yes |
| <a name="input_project_services"></a> [project\_services](#input\_project\_services) | List of services to enable on the project where Vault will run. These services are required in order for this Vault setup to function. | `list(string)` | <pre>[<br>  "compute.googleapis.com",<br>  "iam.googleapis.com"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The region | `any` | n/a | yes |
| <a name="input_service_port"></a> [service\_port](#input\_service\_port) | service port | `number` | `80` | no |
| <a name="input_use_internal_lb"></a> [use\_internal\_lb](#input\_use\_internal\_lb) | use internal LB or not | `bool` | `false` | no |
| <a name="input_vm_instance_labels"></a> [vm\_instance\_labels](#input\_vm\_instance\_labels) | Labels to apply to the vm instances. | `map(string)` | `{}` | no |
| <a name="input_vm_instance_tags"></a> [vm\_instance\_tags](#input\_vm\_instance\_tags) | Additional tags to apply to the instances, please note the service account is used as much as possible as best practice | `list(string)` | `[]` | no |
| <a name="input_vm_machine_type"></a> [vm\_machine\_type](#input\_vm\_machine\_type) | machine type for appliance | `string` | `"e2-standard-4"` | no |
| <a name="input_vm_zones"></a> [vm\_zones](#input\_vm\_zones) | The zones | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_FMC_Public_IP"></a> [FMC\_Public\_IP](#output\_FMC\_Public\_IP) | Public IP of FMC |
| <a name="output_FTD_Public_IP"></a> [FTD\_Public\_IP](#output\_FTD\_Public\_IP) | Public IP of FMC |
| <a name="output_ftd_vm_external_ips"></a> [ftd\_vm\_external\_ips](#output\_ftd\_vm\_external\_ips) | external ips for vm |
| <a name="output_networks_list"></a> [networks\_list](#output\_networks\_list) | list of networks |
| <a name="output_networks_map"></a> [networks\_map](#output\_networks\_map) | map of networks |
