provider "aws" {
    region = "us-east-1"
    access_key = var.access_key
    secret_key = var.secret_key
    default_tags {
        tags = {
            Env = var.environment
        }
    }
}

terraform {
    backend "s3" {
        bucket = "mentorship-terraform-state-storage-sandbox"
        key = "backend.tfstate"
        region = "us-east-1"
        dynamodb_table = "tf-state-locks-sandbox"
        encrypt = true
    }
}
