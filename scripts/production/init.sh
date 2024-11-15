ENV="production"
rm -rf .terraform
terraform init \
    -backend-config="bucket=${ENV}-task-project-terraform-state-file" \
    -backend-config="dynamodb_table=${ENV}-task-project-terraform-lock" \
    -backend-config="key=${ENV}/task-project/terraform.tfstate" && \
terraform workspace new ${ENV} || echo "---" && \
terraform workspace select ${ENV} && \
terraform validate && \
terraform fmt -recursive