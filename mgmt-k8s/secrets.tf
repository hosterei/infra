data "aws_ssm_parameter" "hcloud_token" {
  name = "/hosterei/infra/hcloudToken"
}

data "aws_ssm_parameter" "ssh_private_key" {
  name = "/hosterei/infra/sshPrivateKey"
}

data "aws_ssm_parameter" "ssh_public_key" {
  name = "/hosterei/infra/sshPublicKey"
}