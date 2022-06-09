terraform {
  cloud {
    organization = "hosterei"

    workspaces {
      name = "mgmt-k8s"
    }
  }
}


###################
#  fetch secrets  #
###################
variable "vault_login_username" {
  default   = ""
  sensitive = true
}

variable "vault_login_password" {
  default   = ""
  sensitive = true
}

variable "ssh_public_key" {
  default   = ""
  sensitive = true
}

provider "vault" {
  address = "https://vault.ounu.ch"
  auth_login {
    path = "auth/userpass/login/${var.vault_login_username}"

    parameters = {
      password = "${var.vault_login_password}"
    }
  }
}

data "vault_generic_secret" "hetzner_tokens" {
  path = "ounu/hetzner/tokens"
}