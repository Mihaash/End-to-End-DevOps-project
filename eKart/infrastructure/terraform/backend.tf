# Terraform configuration for eKart deployment

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }

  backend "s3" {
    bucket         = "ekart-terraform-state"
    key            = "global/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = "ekart-terraform-lock"
    encrypt        = true
  }
}
