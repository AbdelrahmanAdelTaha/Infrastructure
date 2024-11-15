ENV="staging"
terraform plan -var-file ./tfvars/${ENV}.tfvars -out ${ENV}.plan