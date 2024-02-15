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

* Input variables parameterize Terraform configurations. Local values save the results of an expression. 
  Output values pass data around, either back to the user or to other modules.
* `for` expressions allow to transform one complex type into another( can be combined with other for expressions to 
  create higher-order functions)
* don't use legacy functions such as uuid() and timestamp()
* Zip files with the Archive provider. You may need to specify an explicit dependency to ensure 
  that the data source runs at the right time.
* `templatefile()` can be used with template files
* The `count` meta argument can dynamically provision multiple instances of a resource (use bracket notation [] for element's access)

# Advantages and Convenience of Terraform for multi-tier projects

* Complex projects, such as multi-tiered web applications in AWS, are easy to design and deploy with the help of Terraform modules.
* The root module is the main entry point for TF project. Variables at the root level are defined in a variables' definition file (terraform.tfvars).
These variables are then trickled down as necessary into child modules.
* Nested modules are used to organize code into child modules. Child modules can be nested within other child modules without limit. 
* There are public TF modules which have been published to the public Terraform Registry. One can save a lot of time 
by using these open source modules
* Data is passed between modules using bubble-up and trickle-down techniques. Since this can result in a lot of boilerplate, 
 it'd be a good idea to optimize code to minimize data to be passed between modules.

# Keeping and managing TF state (backup and S3 backend)

* An S3 backend is used for remotely storing state files. It’s made up of four components: 
  * a DynamoDB table
  * an S3 bucket
  * a KMS key
  * a least-privileged IAM role housekeeping resources.
* Flat modules organize code by using a lot of little .tf files rather than having nested modules. 
  The advantage is that they use less boilerplate, but the con is that it may be harder to reason about the code.
* Modules can be shared through various means including S3 buckets, GitHub repos, and the Terraform Registry (one can 
  also implement your own private module registry)
* Workspaces allow you to deploy to multiple environments. The configuration code stays the same
  (only things variables and the state file are changing)

# Organizing zero-downtime deployments

* The lifecycle block has many flags that allow for customizing resource lifecycles.
* Performing Blue/Green deployments in Terraform is more a technique than a first-class feature. 
* Terraform can be combined with Ansible by using a two-stage deployment technique:
  * In the first stage, Terraform deploys the static infrastructure
  * In the second stage, Ansible deploys applications on top of that infrastructure.
* The TLS provider makes it easy to generate SSH key pairs. One can write out the private key to a .pem file using the Local provider.
* `remote-exec` provisioners are no different from `local-exec` provisioners, except they run on a remote machine instead of the local machine. 
  They output to normal Terraform logs and can be used in place of `user_init` data or pre-baked AMIs.

# Testing in Terraform

* `terraform taint` manually marks resources for destruction and re-creation. It can be used to rotate AWS access keys 
  or other time-sensitive resources.
* A flat module can be converted into nested modules with the help of module expansions. Module expansions permit 
  the use of `for_each` and `count` on modules, as with resources.
* The `terraform state mv` command moves resources and modules around, while `terraform state rm` removes them.
* Unmanaged resources can be converted to managed resources by importing them with `terraform import` ( the same as 
 performing `terraform refresh` on existing resources)
* Integration tests for Terraform modules can be written using a testing framework such as 
 [Terratest](https://terratest.gruntwork.io/docs/getting-started/quick-start/) or terraform-exec. 
 A typical testing pattern is to initialize Terraform, then run the apply operation, then validate outputs, and 
 eventually destroy infrastructure.

# Extending Terraform

* _Terraform providers_ make it easy for people to use APIs without knowing how they work ("black box")
* Providers expose resources and data sources to Terraform. These are implemented as functions referenced by the provider schema.
* Managed resources implement CRUD operations: Create, Read, Update, and Delete. These methods are invoked when the relevant lifecycle event is triggered.
* Acceptance testing means writing tests for the provider schema and any resources exposed by the provider. 
  Acceptance testing hardens code and is crucial for production readiness.
* A provider is built like any other golang program (implies a CI/CD pipeline to automate building, testing, 
  publishing, and distributing the provider)

# Scalability and deploying infrastructure _et masse_

* Terraform can be run at scale as part of an automated CI/CD pipeline.
* A typical Terraform CI/CD pipeline consists of four stages: 
  * Source
  * Plan
  * Approve
  * Apply.
* JSON syntax is favored over HCL when generating configuration code. Although it’s generally more verbose and harder to read than HCL, JSON is
more machine-friendly and has better library support.
* Dynamic blocks can be toggled on or off with a boolean flag (a code block may exist or not exist depending on the result of a conditional expression.
* Static secrets should be set as environment variables whenever possible ( as the last resort maintain
 a separate `secrets.tfvars` file explicitly for this purpose)
* Dynamic secrets are far safer than static secrets because they are created on demand and valid for only the period 
  of time they will be used. One can read dynamic secrets with the corresponding data source from Vault or the AWS provider.
* Sentinel can enforce policy as code. Sentinel policies automatically reject Terraform runs based on the contents 
  of the configuration code or the results of a plan.

