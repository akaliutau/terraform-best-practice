# Key concepts about Terraform

# Basics

* Terraform is a declarative IaC provisioning tool, which can deploy resources onto any public/private cloud.
* Terraform is 
  * a provisioning tool
  * free and open source
  * declarative
  * cloud-agnostic
  * expressive and extensible
* The major elements of Terraform are _resources_, _data sources_, and _providers_.
* Code blocks can be chained together to perform dynamic deployments.
* To deploy a Terraform project, you must first write configuration code, then configure providers and other input variables, 
  initialize Terraform, plan and then apply changes:
```shell
terraform init
terraform plan
terraform apply -auto-approve
```

## Notes to consider:
* `terraform init` creates a local cache with provider binary, and this step can be slow - consider add this folder to
  cached file paths when running this step at CI pipeline

