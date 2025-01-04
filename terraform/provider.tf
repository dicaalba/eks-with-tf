terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.70.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }

  backend "s3" {
    bucket         = "eks-terraform-test-2024"
    dynamodb_table = "terraform_state"
    key            = "tesis"
    region         = "us-east-1"
  }

}

provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

# Same parameters as kubernetes provider
provider "kubectl" {
  load_config_file       = false
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}