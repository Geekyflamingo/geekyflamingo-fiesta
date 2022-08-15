terraform {
  required_version = "~> 1.2.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.26.0"
    }
  }

  backend "s3" {
    bucket = "lobo-zorra-static-terraform-state-files"
    key    = "prod/terraform.tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  alias  = "route53_provider"
  region = "us-east-1"
}