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
      version = ">= 1.35.2"
    }
  }
}


## Hetzner Cloud
provider "hcloud" {
  token = local.hcloud_token
}

## AWS
variable "AWS_ACCESS_KEY_ID" {
  sensitive: true
  default = ""
}

variable "AWS_SECRET_ACCESS_KEY" {
  sensitive: true
  default = ""
}
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY

}