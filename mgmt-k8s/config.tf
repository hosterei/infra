terraform {
  cloud {
    organization = "hosterei"

    workspaces {
      name = "mgmt-k8s"
    }
  }
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