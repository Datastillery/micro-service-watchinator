# MicroServiceWatchinator

Watches micro-services for the Smart Columbus Operating System

Need to run `git submodule update --init --recursive` to get the streaming_metrics module before building

Deploying to your favorite sandbox EKS can be done using terraform.  Make sure you select a workspace that reflect your sandbox's

# Deploying Via Terraform
```
env=dev
terraform init -backend-config=../common/backends/alm.conf
terraform workspace new $env
terraform plan --var-file=variables/$env.tfvars -var 'watchinator_image_name=199837183662.dkr.ecr.us-east-2.amazonaws.com/scos/micro-service-watchinator:<Image Tag>' --out=my.out
terraform apply my.out
```
