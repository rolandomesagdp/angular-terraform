resource "aws_s3_bucket" "angular_app_bucket" {
  bucket = "rolandomesagdp-angular-app"
}

resource "aws_s3_bucket_website_configuration" "angular_app_website_configuration" {
  bucket = aws_s3_bucket.angular_app_bucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket.angular_app_bucket]
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.angular_app_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
  depends_on = [aws_s3_bucket.angular_app_bucket, aws_s3_bucket_public_access_block.angular_app_bucket_public_access_block]
}

resource "aws_s3_bucket_public_access_block" "angular_app_bucket_public_access_block" {
  bucket = aws_s3_bucket.angular_app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  depends_on              = [aws_s3_bucket.angular_app_bucket]
}

resource "aws_s3_bucket_policy" "allow_public_read_object_bucket_policy" {
  bucket = aws_s3_bucket.angular_app_bucket.id
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [{
      Sid : "PublicReadGetObject",
      Effect : "Allow",
      Principal : "*",
      Action : "s3:GetObject",
      Resource : "${aws_s3_bucket.angular_app_bucket.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.angular_app_bucket_public_access_block]
}
