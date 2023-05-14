locals {
  # Fill first and foremost your Hetzner API token, found in your project, Security, API Token, of type Read & Write.
  hcloud_token = data.aws_ssm_parameter.hcloud_token.value
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
  # version = "1.6.9"


  # * Your ssh public key
  ssh_public_key  = data.aws_ssm_parameter.ssh_public_key.value
  ssh_private_key = data.aws_ssm_parameter.ssh_private_key.value

  # disblae local kubeconfig. The kubeconfig file can instead be created by executing: "terraform output --raw kubeconfig > cluster_kubeconfig.yaml"
  create_kubeconfig = false

  # * For Hetzner locations see https://docs.hetzner.com/general/others/data-centers-and-connection/
  network_region = "eu-central" # change to `us-east` if location is ash

  control_plane_nodepools = [
    # {
    #   name        = "control-plane-nbg1",
    #   server_type = "cp21",
    #   location    = "nbg1",
    #   labels      = [],
    #   taints      = [],
    #   count       = 2
    # },
    {
      name        = "control-plane-fsn1",
      server_type = "cpx21",
      location    = "nbg1",
      labels      = [],
      taints      = [],
      count       = 1
    }
  ]

  agent_nodepools = [
    {
      name        = "hosterei-wrk-0",
      server_type = "cx21",
      location    = "nbg1",
      labels      = [],
      taints      = [],
      count       = 3
    },
    {
      name        = "hosterei-mgmt",
      server_type = "cpx11",
      location    = "nbg1",
      labels = [
        "node.kubernetes.io/server-usage=mgmt"
      ],
      taints = [
        "server-usage=mgmt:PreferNoSchedule"
      ],
      count = 1
    }
  ]

  # Cluster Autoscaler
  # Providing at least one map for the array enables the cluster autoscaler feature, default is disabled
  # Please note that the autoscaler should not be used with initial_k3s_channel < "v1.25". So ideally lock it to "v1.25".
  # * Example below:
  autoscaler_nodepools = [
    {
      name        = "autoscaler"
      server_type = "cp21" # must be same or better than the control_plane server type (regarding disk size)!
      location    = "nbg1"
      min_nodes   = 0
      max_nodes   = 5
    }
  ]

  # * LB location and type, the latter will depend on how much load you want it to handle, see https://www.hetzner.com/cloud/load-balancer
  load_balancer_type     = "lb11"
  load_balancer_location = "nbg1"

  # If you want to disable the Traefik ingress controller, you can can set this to "false". Default is "true".
  ingress_controller = "none"

}



