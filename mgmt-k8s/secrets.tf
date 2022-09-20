provider "vault" {
  address = "https://vault.ounu.ch"
  auth_login {
    path = "auth/userpass/login/${var.vault_login_username}"

    parameters = {
      password = "${var.vault_login_password}"
    }
  }
}

###################
#   define vars   #
###################
variable "vault_login_username" {
  default   = ""
  sensitive = true
}

variable "vault_login_password" {
  default   = ""
  sensitive = true
}

###################
#  fetch secrets  #
###################
data "vault_generic_secret" "hetzner_tokens" {
  path = "ounu/hetzner/tokens"
}
data "vault_generic_secret" "ssh" {
  path = "ounu/mgmt/k8s/ssh"
}

#####################
# upload kubeconfig #
#####################
resource "vault_generic_secret" "kubeconfig" {
  path = "ounu/mgmt/k8s/kubeconfig"

  data_json = jsonencode(
  {
    kubeconfig       = "${module.kube-hetzner.kubeconfig_file}"
  }
  )
}