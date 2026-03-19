terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 1.13.4"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}
