# Terraform Modules for Cisco Secure Firewall Threat Defense deployment in GCP

## Overview

A set of modules to deploy Cisco Secure Firewall Threat Defense virtual instances including the network infrastucture around it based on user requirements in GCP.

## Structure

This repository has the following directory structure:

**modules** - this directory contains individual terraform modules that can be used to cover different usecases when deploying Cisco Secure FTD.

**examples** - this directory contains different use-case examples of deploying Cisco Secure FMC and FTD.

This is a module for [Cisco FTD+FMC in GCP](https://www.cisco.com/c/en/us/td/docs/security/firepower/quick_start/fmcv/fpmc-virtual/fpmc-virtual-gcp.html). 


## Compatibility

This module is meant for use with Terraform version >=1.0.0.

## FMC version supported
* 7.3

## Use cases
Terraform plan will create a pair of FTD & FMC on GCP based on the following configurations: 
* ### Single FTD & Single FMC: 
  When **num_instances** input variable is **1**, the terraform creates only one FTD & FMC.
* ### Multiple FTDs & Single FMC:
  When **num_instances** input variable is **2**, the terraform creates two FTDs & FMC.

  Extra appliance_ips are passed to the list "network" to support the increased number of instances.
## Example usage
Examples of how to use these modules can be found in the [examples](examples/) folder.
- [Single instance](examples/single-instance)
- [Mutiple instance](examples/multi-instance)

### (Optional) Set up a GCS backend
```bash
cd examples/single-instance
```
Add backend.tf accordingly,

```hcl
terraform {
  backend "gcs" {
    bucket = "<a-unique-bucket-for-terraform-states>"
    prefix = "fmc/single-instance"
  }
}
```

### Generate a ssh key pair with 2048 bits key as 2048 bits is supported by FMC.


```bash
# Generate a ssh key pair with 2048 bits key as 2048 bits is supported by ASA
ssh-keygen -t rsa -b 2048 -f admin-ssh-key
```

### Execute Terraform for creating the appliances.

```bash
cd examples/single-instance
# modify the  terraform.tfvars to make sure all the values fit the use case 
# such as admin_ssh_pub_key
terraform init 
terraform plan
terraform apply
terraform destroy
```
### Screenshots of SSH and HTTPS UI
FMC SSH session
```bash
IP_ADDRESS=$(terraform output -json vm_external_ips  | jq -r '.[0]')
ssh -i admin-ssh-key admin@$IP_ADDRESS
```

Please go to FMC GUI via *https://${IP_ADDRESS}/* in a browser.
![FMC GUI](images/fmc_ui.png)

## Source code files naming convention

* locals.tf: local variables
* variables.tf: input variables
* outputs.tf: output variables
* datasource.tf: define data source such as zones, compute images and template.
* network.tf: define VPC networks, custom routes.
* firewall.tf: define firewall rules.