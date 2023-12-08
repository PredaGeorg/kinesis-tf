resource "aws_s3_bucket" "demo_bucket" {
  bucket = "${var.kinesis_data_stream}-data"
}

resource "aws_s3_bucket_acl" "kinesis_bucket_acl" {
  bucket = aws_s3_bucket.demo_bucket.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.demo_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}
