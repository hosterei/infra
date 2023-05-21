apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  # upstream repo
  - https://github.com/hosterei/gitops.git/

patches:
- patch: |-
    apiVersion: v1
    kind: Secret
    metadata:
      name: vault-env
    type: Opaque
    stringData:
      AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}"
      AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}"
