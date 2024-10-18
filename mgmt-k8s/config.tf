terraform {
  backend "s3" {
    bucket = "hosterei-tf-state"
    key    = "mgmt-k8s/prd"
    region = "eu-central-1"
  }

  required_version = ">= 1.3.3"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.43.0"
    }
  }
}


## Hetzner Cloud
provider "hcloud" {
  token = local.hcloud_token
}

provider "aws" {
  region = "eu-central-1"

}