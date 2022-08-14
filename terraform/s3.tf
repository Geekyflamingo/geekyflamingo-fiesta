resource "aws_s3_bucket" "static-website-bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "static-website-bucket-versioning" {
  bucket = aws_s3_bucket.static-website-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static-website-bucket" {
  bucket = aws_s3_bucket.static-website-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "static-website-bucket-public-read-policy" {
  bucket = aws_s3_bucket.static-website-bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "staticWebsiteS3policy"
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })
}


resource "aws_s3_bucket_website_configuration" "static-website-bucket" {
  bucket = aws_s3_bucket.static-website-bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}