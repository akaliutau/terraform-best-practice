# Terraform best practice

This repository contains overview of Terraform IaaC tool and sample designs for a couple of use cases demonstrating how to apply TF to solve DevOps problems 

# Prerequisites

## Creating non-root IAM user for tests

(follow the instructions [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-set-up.html#create-an-admin) )

1. Create a user `tf-admin` with `AdministratorAccess` policy
2. Install awscli: https://aws.amazon.com/cli, normally the procedure looks like this and installs all binary in
   `/usr/local/bin/aws`:
```shell
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install [--update]
aws --version
aws-cli/2.15.15 Python/3.11.6 Linux/5.15.0-92-generic exe/x86_64.ubuntu.20 prompt/off
```

Under the Security Credentials tab, one can then create access keys to authenticate against AWS service APIs - 
either set these directly as environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` or use proxy
via awscli (aws console app keeps access codes in property file `$HOME/.aws/credentials`)

One can add new creds via command:

```shell
aws configure --profile tf-admin
```

Things to remember: 

* the ARN of owner (TF user) in the form `arn:aws:iam::<project_id>:user/tf-admin`, where `project_is` is a 12-digit number
* Console sign-in URL (usually have the form https://<project_id>.signin.aws.amazon.com/console)
* password for console to log in
* access keys - they must be kept secure

# Projects

`minimal-project` - creates a small VPC with 1 t2.micro instance accessible via SSH - can be handy in case a VM machine
is needed to quickly perform some compute-intense experiments  (VM can have TBs of memory). More details [here](./minimal-project/HOWTO.md)

`ci-pipeline` - shows how to define in code AWS-cloud native pipeline which in its turn can use Terraform to deploy infrastructure (cascading IaaC). 
More details [here](./ci-pipeline/HOWTO.md)

`multi-tier-webapp` - 3-tier project in React + Go - TBA


# Terraform notes

General notes, philosophy and misc topics can be found [here](./notes/concepts.md)