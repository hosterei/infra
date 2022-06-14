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
  # For normal use, this is the path to the terraform registry
  source = "git::https://github.com/oujonny/kube-hetzner.git?ref=feat/ccm_default_lb_location"
  # you can optionally specify a version number
  # version = "1.2.0"

  # Note that some values, notably "location" and "public_key" have no effect after initializing the cluster.
  # This is to keep Terraform from re-provisioning all nodes at once, which would lose data. If you want to update
  # those, you should instead change the value here and manually re-provision each node. Grep for "lifecycle".

  # * Your ssh public key
  ssh_public_key = data.vault_generic_secret.ssh.data["publicKey"]
  # * Your private key must be "ssh_private_key = null" when you want to use ssh-agent for a Yubikey-like device authentification or an SSH key-pair with a passphrase.
  # For more details on SSH see https://github.com/kube-hetzner/kube-hetzner/blob/master/docs/ssh.md
  ssh_private_key = data.vault_generic_secret.ssh.data["privateKey"]
  # You can add additional SSH public Keys to grant other team members root access to your cluster nodes.
  # ssh_additional_public_keys = []

  # If you want to use an ssh key that is already registered within hetzner cloud, you can pass its id.
  # If no id is passed, a new ssh key will be registered within hetzner cloud.
  # It is important that exactly this key is passed via `ssh_public_key` & `ssh_private_key` vars. 
  # hcloud_ssh_key_id = ""

  # These can be customized, or left with the default values
  # * For Hetzner locations see https://docs.hetzner.com/general/others/data-centers-and-connection/
  network_region = "eu-central" # change to `us-east` if location is ash

  # For the control planes, at least three nodes are the minimum for HA. Otherwise, you need to turn off the automatic upgrade (see ReadMe).
  # As per Rancher docs, it must always be an odd number, never even! See https://rancher.com/docs/k3s/latest/en/installation/ha-embedded/
  # For instance, one is ok (non-HA), two is not ok, and three is ok (becomes HA). It does not matter if they are in the same nodepool or not! So they can be in different locations and of various types.

  control_plane_nodepools = [
    {
      name        = "control-plane-fsn1",
      server_type = "cpx11",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 1
    }
  ]

  agent_nodepools = [
    {
      name        = "agent-small",
      server_type = "cpx21",
      location    = "fsn1",
      labels      = [],
      taints      = [],
      count       = 2
    }
  ]

  # * LB location and type, the latter will depend on how much load you want it to handle, see https://www.hetzner.com/cloud/load-balancer
  load_balancer_type     = "lb11"
  load_balancer_location = "fsn1"

  # If you want to disable the Traefik ingress controller, you can can set this to "false". Default is "true".
  traefik_enabled = false

  # If you want to disable the metric server, you can! Default is "true".
  metrics_server_enabled = false

  # If you want to allow non-control-plane workloads to run on the control-plane nodes, set "true" below. The default is "false".
  # True by default for single node clusters.
  allow_scheduling_on_control_plane = true

  # If you want to disable the automatic upgrade of k3s, you can set this to false. The default is "true".
  # automatically_upgrade_k3s = false

  # Allows you to specify either stable, latest, testing or supported minor versions (defaults to stable)
  # see https://rancher.com/docs/k3s/latest/en/upgrades/basic/ and https://update.k3s.io/v1-release/channels
  # initial_k3s_channel = "latest"

  # The cluster name, by default "k3s"
  cluster_name = "mgmt-k8s"

  # Whether to use the cluster name in the node name, in the form of {cluster_name}-{nodepool_name}, the default is "true".
  use_cluster_name_in_node_name = false
}

provider "hcloud" {
  token = local.hcloud_token
}

terraform {
  required_version = ">= 1.2.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.0.0"
    }
  }
}
