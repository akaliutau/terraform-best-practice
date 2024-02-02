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

# Terraform lifecycle

* Resources are created in a certain sequence as dictated by the execution plan.
* The sequence is calculated based on implicit dependencies (topologically sorted)
* Each managed resource has life cycle function hooks associated with it: Create() , Read() , Update() , and Delete(). 
  Terraform invokes these function hooks as part of its normal operations.
* Changing Terraform configuration code and running terraform apply will update an existing managed resource. 
  One can also use `terraform refresh` to update the state file based on what is currently deployed.
* Terraform reads the state file during a plan to decide what actions to take during apply. 

There is a `Local provider` for Terraform, which allows to create and manage text files on your machine. 

# HCL

Input variables parameterize Terraform configurations. Local values save the

results of an expression. Output values pass data around, either back to the user
or to other modules.
for expressions allow you to transform one complex type into another. They
can be combined with other for expressions to create higher-order functions.
Randomness must be constrained. Avoid using legacy functions such as uuid()
and timestamp() , as these will introduce subtle bugs in Terraform due to a
non-convergent state.
Zip files with the Archive provider. You may need to specify an explicit depen-
dency to ensure that the data source runs at the right time.
templatefile() can template files with the same syntax used by interpolation
variables. Only variables passed to this function are in scope for templating.
The count meta argument can dynamically provision multiple instances of a
resource. To access an instance of a resource created with count , use bracket
notation [] .
