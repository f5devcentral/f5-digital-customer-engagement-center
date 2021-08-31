# Create the Storage Account
resource "aws_s3_bucket" "main" {
  bucket        = format("%sstorage%s", var.projectPrefix, random_id.buildSuffix.hex)
  acl           = "private"
  force_destroy = true
  tags = {
    Name                    = format("%sstorage%s", var.projectPrefix, random_id.buildSuffix.hex)
    Owner                   = var.resourceOwner
    f5_cloud_failover_label = format("%s-%s", var.projectPrefix, random_id.buildSuffix.hex)
  }
}
