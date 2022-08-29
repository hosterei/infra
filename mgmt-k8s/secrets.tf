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
resource "vault_mount" "ounu" {
  path        = "ounu"
  type        = "kv"
  options     = { version = "2" }
}

resource "vault_kv_secret_v2" "kubeconfig" {
  mount                      = vault_mount.ounu.path
  name                       = "secret"
  cas                        = 1
  delete_all_versions        = false
  data_json                  = jsonencode(
  {
    kubeconfig       = "${module.kube-hetzner.kubeconfig_file}"
  }
  )
}