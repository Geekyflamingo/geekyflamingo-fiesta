terraform {
  required_version = "~> 1.2.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.26.0"
    }
  }

  backend "s3" {
    bucket = "becca-v-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-west-1"
  }
}

provider "aws" {
  region = "us-west-1"
}
