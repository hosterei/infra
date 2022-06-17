###################
# provider config #
###################

provider "hcloud" {
  token = data.vault_generic_secret.hetzner_tokens.data["hcloud_token"]
}
provider "hetznerdns" {
  apitoken = data.vault_generic_secret.hetzner_tokens.data["hdns_token"]
}

data "hetznerdns_zone" "ounu_ch" {
  name = "ounu.ch"
}

data "template_file" "cloudinit" {
  template = file("./files/cloudinit.tmpl")
  vars = {
    external_url = "https://gitlab.ounu.ch"
    rootPassword = data.vault_generic_secret.gitlab_passwords.data["rootPassword"]
  }
}

resource "hcloud_server" "gitlab" {
  name        = "gitlab"
  image       = "gitlab"
  server_type = "cx21"
  location    = "nbg1"
  ssh_keys    = ["${data.vault_generic_secret.ssh.data["publicKey"]}"]
  keep_disk   = true
  user_data   = data.template_file.cloudinit.rendered
}

resource "hetznerdns_record" "gitlab" {
  zone_id = data.hetznerdns_zone.ounu_ch.id
  name    = "gitlab"
  value   = hcloud_server.gitlab.ipv4_address
  type    = "A"
  ttl     = 60
}
