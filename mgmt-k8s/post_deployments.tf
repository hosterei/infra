
# data "github_repository" "argoproj_argo-cd" {
#   full_name = "argoproj/argo-cd"
# }

# data "github_repository" "argoproj-labs_argocd-vault-plugin" {
#   full_name = "argoproj-labs/argocd-vault-plugin"
# }

data "github_repository_file" "argocd_ha_install" {
  repository          = "argoproj/argo-cd"
  branch              = "master"
  file                = "manifests/ha/install.yaml"
}

data "github_repository_file" "argocd_vault_repo_server" {
  repository          = "argoproj-labs/argocd-vault-plugin"
  branch              = "main"
  file                = "manifests/cmp-sidecar/argocd-repo-server.yaml"
}

data "github_repository_file" "argocd_vault_cm" {
  repository          = "argoproj-labs/argocd-vault-plugin"
  branch              = "main"
  file                = "manifests/cmp-sidecar/cmp-plugin.yaml"
}
