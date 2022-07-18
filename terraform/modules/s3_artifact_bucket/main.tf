resource "aws_s3_bucket" "artifact_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    { Name = var.bucket_name }
  )
}

resource "aws_s3_bucket_acl" "artifact_bucket_acl" {
  bucket = aws_s3_bucket.artifact_bucket.id
  acl    = var.bucket_acl
}
