terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.28"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = ">=1.2.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.6.0"
    }
  }
}
