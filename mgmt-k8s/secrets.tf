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

variable "ssh_public_key" {
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