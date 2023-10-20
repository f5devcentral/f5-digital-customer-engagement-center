# Create the Storage Account
resource "aws_s3_bucket" "main" {
  bucket        = format("%sstorage%s", var.projectPrefix, random_id.buildSuffix.hex)
  force_destroy = true
  tags = {
    Name                    = format("%sstorage%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner                   = var.resourceOwner
    f5_cloud_failover_label = format("%s-%s", var.projectPrefix, random_id.buildSuffix.hex)
  }
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "main" {
  depends_on = [aws_s3_bucket_ownership_controls.main]

  bucket = aws_s3_bucket.main.id
  acl    = "private"
}