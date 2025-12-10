terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  backend "s3" {
               bucket   = "my-eks-terraform-state-5856"
                        key            = "eks/terraform.tfstate"
                        region         = "ap-south-1"
                        dynamodb_table = "terraform-lock-table1"
                        encrypt        = true
                                                }
}
