terraform {
  backend "s3" {
    bucket         = "tfstate-deploy-testing"
    key            = "rails-ecs-app-config-spike/deploy-testing/us-east-1"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tflock-deploy-testing"
    kms_key_id     = "0f003f71-d51b-429e-82c1-e587935f1597"
    role_arn       = "arn:aws:iam::902839739775:role/terraform-backend-manager"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
