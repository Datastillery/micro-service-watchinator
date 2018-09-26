data "terraform_remote_state" "env_remote_state" {
  backend   = "s3"
  workspace = "${terraform.workspace}"

  config {
    bucket   = "${var.alm_state_bucket_name}"
    key      = "operating-system"
    region   = "us-east-2"
    role_arn = "${var.alm_role_arn}"
  }
}

resource "local_file" "kubeconfig" {
  filename = "${path.module}/outputs/kubeconfig"
  content = "${data.terraform_remote_state.env_remote_state.eks_cluster_kubeconfig}"
}


resource "local_file" "helm_vars" {
  filename = "${path.module}/outputs/${terraform.workspace}.yaml"
  content = <<EOF
cronjob:
  consumerUri: wss://streaming.${data.terraform_remote_state.env_remote_state.hosted_zone_name}/socket/websocket
  image: ${var.watchinator_image_name}
EOF
}


resource "null_resource" "helm_deploy" {
  provisioner "local-exec" {
    command = <<EOF
export KUBECONFIG=${local_file.kubeconfig.filename}

helm upgrade --install ${var.watchinator_deploy_name} micro-service-watchinator/ \
    --namespace watchinator \
    --values ${local_file.helm_vars.filename}
EOF
  }

  triggers {
    # Triggers a list of values that, when changed, will cause the resource to be recreated
    # ${uuid()} will always be different thus always executing above local-exec
    hack_that_always_forces_null_resources_to_execute = "${uuid()}"
  }
}

variable "alm_role_arn" {
  description = "The ARN for the assume role for ALM access"
  default     = "arn:aws:iam::199837183662:role/jenkins_role"
}

variable "alm_state_bucket_name" {
  description = "The name of the S3 state bucket for ALM"
  default     = "scos-alm-terraform-state"
}

variable "watchinator_deploy_name" {
  description = "The helm deploy name to give to the watchinator"
  default     = "watchinator"
}

variable "watchinator_image_name" {
  description = "The name of the docker image to be deployed as the watchinator"
  default     = "watchinator:latest"
}