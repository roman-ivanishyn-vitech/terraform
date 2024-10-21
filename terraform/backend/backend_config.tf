resource "aws_s3_bucket" "state_storage" {
  bucket = "mentorship-terraform-state-storage-${var.environment}"
  tags = local.tags
}

resource "aws_s3_bucket_versioning" "state_storage_versioning" {
  bucket = aws_s3_bucket.state_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_storage_encryption" {
  bucket = aws_s3_bucket.state_storage.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "state_locks" {
  hash_key       = "LockID"
  name           = "tf-state-locks-${var.environment}"
  read_capacity  = 1
  write_capacity = 1
  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.dynamodb_kms_key.arn
  }
  attribute {
    name = "LockID"
    type = "S"
  }
  point_in_time_recovery {
    enabled = true
  }
  tags = local.tags
}

resource "aws_kms_key" "dynamodb_kms_key" {
  enable_key_rotation = true
  tags = local.tags
}
