terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0" 
      #provider-version
    }
  }
  backend "s3" {
    bucket = "daws-remote-state"
    # key name is to specify remote state files in aws- change the key name according to infra creation
    key    = "provisioners"
    region = "us-east-1"
    dynamodb_table = "daws-locking"
  }
}

provider "aws" {
    region = "us-east-1"
}