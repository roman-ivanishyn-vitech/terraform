provider "aws" {
    region = "us-east-1"
    default_tags {
        tags = {
            Env = var.environment
        }
    }
}

terraform {
    backend "s3" {
        bucket = "mentorship-terraform-state-storage-sandbox"
        key = "app.tfstate"
        region = "us-east-1"
        dynamodb_table = "tf-state-locks-sandbox"
        encrypt = true
    }
}
