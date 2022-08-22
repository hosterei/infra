provider "kustomization" {
  kubeconfig_raw = module.kube-hetzner.kubeconfig_file
}

data "kustomization" "post_deployment_kustomize" {
  # path to kustomization directory
  path = "post-deployment-kustomize/"
}

resource "kustomization_resource" "argocd" {
  for_each = data.kustomization.post_deployment_kustomize.ids
  manifest = data.kustomization.post_deployment_kustomize.manifests[each.value]
}