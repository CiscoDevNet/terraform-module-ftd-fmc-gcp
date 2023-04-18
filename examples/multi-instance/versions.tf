terraform {
  required_version = ">=v1.3.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.80, <4.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.80, <4.0"
    }

    template = {
      version = "~> 2.2.0"
    }


  }
}