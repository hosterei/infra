apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
  # upstream repo
  - "https://github.com/hosterei/gitops.git/"

patchesStrategicMerge:
  - |-
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: argocd-repo-server
    spec:
      template:
        spec:
          containers:
            - name: argocd-repo-server
              env:
                - name: AVP_TYPE
                  value: awsssmparameterstore
                - name: AWS_REGION
                  value: eu-central-1
                - name: AWS_ACCESS_KEY_ID
                  value: "${AWS_ACCESS_KEY_ID}"
                - name: AWS_SECRET_ACCESS_KEY
                  value: "${AWS_SECRET_ACCESS_KEY}"