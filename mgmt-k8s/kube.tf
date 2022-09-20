locals {
  # Fill first and foremost your Hetzner API token, found in your project, Security, API Token, of type Read & Write.
  hcloud_token = data.vault_generic_secret.hetzner_tokens.data["hcloud_token"]
}

module "kube-hetzner" {
  providers = {
    hcloud = hcloud
  }
  hcloud_token = local.hcloud_token

  # Then fill or edit the below values. Only the first values starting with a * are obligatory; the rest can remain with their default values, or you
  # could adapt them to your needs.

  # * For local dev, path to the git repo
  #source = "../../../kube-hetzner/"
  #source = "git::https://github.com/oujonny/kube-hetzner.git?ref=feat/generic_post_deployment"

  # For normal use, this is the path to the terraform registry
  source = "kube-hetzner/kube-hetzner/hcloud"
  # you can optionally specify a version number
  version = "1.4.6"


  # * Your ssh public key
  ssh_public_key = data.vault_generic_secret.ssh.data["publicKey"]
  ssh_private_key = data.vault_generic_secret.ssh.data["privateKey"]

  # * For Hetzner locations see https://docs.hetzner.com/general/others/data-centers-and-connection/
  network_region = "eu-central" # change to `us-east` if location is ash

  control_plane_nodepools = [
    {
      name        = "control-plane-fsn1",
      server_type = "cpx21",
      location    = "nbg1",
      labels      = [],
      taints      = [],
      count       = 3
    }
  ]

  agent_nodepools = [
    {
      name        = "agent-small",
      server_type = "cpx21",
      location    = "nbg1",
      labels      = [],
      taints      = [],
      count       = 3
    }
  ]

  # * LB location and type, the latter will depend on how much load you want it to handle, see https://www.hetzner.com/cloud/load-balancer
  load_balancer_type     = "lb11"
  load_balancer_location = "fsn1"

  # If you want to disable the Traefik ingress controller, you can can set this to "false". Default is "true".
  traefik_enabled = false

  # Disable metrics server, because promehteus component is used
  metrics_server_enabled = false

}

provider "hcloud" {
  token = local.hcloud_token
}

terraform {
    cloud {
    organization = "hosterei"

    workspaces {
      name = "mgmt-k8s"
    }
  }
  required_version = ">= 1.2.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.33.2"
    }
    kustomization = {
      source = "kbst/kustomization"
      version = ">= 0.9.0"
    }
    vault = {
      source = "hashicorp/vault"
    }
  }
}
