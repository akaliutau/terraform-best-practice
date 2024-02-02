# CI/CD pipeline and AWS

# What it is

This is a solution design for the CI/CD pipeline which automatically builds applications from source and deploys them to
[provisioned] infrastructure at AWS. Uses under the hood the `CodeStarSourceConnection` actions to integrate with 3rd 
party source code repos: GitHub, GitLab and so on

Everything is defined via Terraform

This is an example of how Terraform can be used to:

* _define_ at AWS a CI pipeline utilising cloud-native pipelining functionality
* _invoke_ Runners with Terraform from within AWS (of course, pipeline can consist from containers running any workload)

Key concepts illustrated:

* modular structure of all templates (useful for complex projects with many dependencies)
* define infrastructure for complex AWS resources

# Running

The first step will be to create a test repo specified in `source_code_repo` variable (terraform.tfvars file) and
authorise AWS to read/write/control GitHub repository with source code ([fig01-1](./pictures/fig01-1.png) 
and  [fig01-2](./pictures/fig01-2.png) )

For running Terraform in the cloud as a part of CloudPipeline the S3 storage is needed (to store the source code and
the TF state)

```shell
terraform --version
cd ci-pipeline/
terraform init -upgrade
terraform plan
terraform apply
terraform show
```


