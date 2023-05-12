provider "aws" {
  region = "eu-central-1"
}

data "aws_ssm_parameter" "hcloud_token" {
  name = "/hosterei/infra/hcloudToken"
}

