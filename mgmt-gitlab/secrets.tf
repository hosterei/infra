###################
#  fetch secrets  #
###################
data "vault_generic_secret" "hetzner_tokens" {
  path = "ounu/hetzner/tokens"
}

data "vault_generic_secret" "gitlab_passwords" {
  path = "ounu/mgmt/gitlab/passwords"
}

data "vault_generic_secret" "ssh" {
  path = "ounu/mgmt/gitlab/ssh"
}
