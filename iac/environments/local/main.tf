terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "rolandomesagdp-terraform-state-bucket"
    key     = "rolandomesagdp/terraform-state"
    region  = "eu-west-1"
    profile = "rolandomesagdp"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "rolandomesagdp"
}

module "angular_s3" {
  source                    = "../../angular-s3"
  angular_build_folder_path = var.angular_build_folder_path
}
