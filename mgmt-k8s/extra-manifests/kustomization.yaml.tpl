apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  # upstream repository
  - https://github.com/hosterei/gitops.git/

resources:
    - vault-env.yaml
