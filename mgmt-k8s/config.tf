terraform {
  backend "s3" {
    bucket = "hosterei-tf-state"
    key    = "mgmt-k8s/prd"
    region = "eu-central-1"
  }
}
