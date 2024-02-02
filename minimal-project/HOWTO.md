# The minimal project

# What it is

Provisions an Ubuntu 20.04 instance at AWS EC2

# Running

## Create ssh key to access the instance

(the filename of the key - id_rsa_aws - should be placed in the root directory for this project)
```shell
ls ~/.ssh
ssh-keygen
chmod 400 id_rsa_aws
```
Note 1: chmod works only on ext3/4 FS,

```shell
terraform --version
cd minimal-project/
terraform init -upgrade
terraform plan
terraform apply -y
terraform show
```

Note 2: may need to subscribe to this Ubuntu software (license limitations) to use it in your projects at AWS, can take 2-3 min

The output:

```shell
aws_key_pair.ssh-key: Creating...
aws_key_pair.ssh-key: Creation complete after 1s [id=ssh-key]
aws_instance.demo: Creating...
aws_instance.demo: Still creating... [10s elapsed]
aws_instance.demo: Still creating... [20s elapsed]
aws_instance.demo: Still creating... [30s elapsed]
aws_instance.demo: Creation complete after 33s [id=i-0a3c2ca7fbd47d1aa]

Apply complete! Resources: 2 added, 0 changed, 1 destroyed.

Outputs:

instance_ip = "3.86.228.1"
```

Login into instance at https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1

1) use the public ip address + dns: https://ec2-<IP without dots>.compute-1.amazonaws.com/ (can be found at Connect to Instance tab)

```shell
sudo ssh -i ./id_rsa_aws ubuntu@ec2-3-86-228-1.compute-1.amazonaws.com
The authenticity of host 'ec2-3-86-228-1.compute-1.amazonaws.com (3.86.228.1)' can't be established.
ECDSA key fingerprint is SHA256:CtjBfMqiss9lO7nETJw/iYSbZgQvUe9xuPkzi0kq6xc.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'ec2-3-86-228-1.compute-1.amazonaws.com,3.86.228.1' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.15.0-1052-aws x86_64)
```

One can check the external network is available:

```shell
ping 8.8.8.8
```

Destroying resources:

```shell
terraform destroy
```

# Troubleshooting

```shell
aws ec2 describe-instance-attribute --region us-east-1 --instance-id i-06e768d07446638c2 --attribute groupSet
```


# References

* [Hashicorp providers: AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

