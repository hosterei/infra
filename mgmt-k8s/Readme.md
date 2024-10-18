# Deploy
1. set those env variables:
```
export TF_VAR_AWS_ACCESS_KEY_ID=...
export TF_VAR_AWS_SECRET_ACCESS_KEY=...
```
2. run `terraform init`
3. run `terraform validate`
3. run `terraform apply --auto-approve`