apiVersion: v1
kind: Secret
metadata:
  name: vault-env
type: Opaque
stringData:
  AVP_TYPE: awsssmparameterstore
  AWS_REGION: eu-central-1
  AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}"
  AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}"