terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

variable "artifacts_bucket_name" {
  type = string
  default = "react-redux-realworld-example-artifacts"
}

variable "app_bucket_name" {
  type = string
  default = "react-redux-realworld-example-app"
}

data "template_file" "bucket_policy" {
  template = file("${path.module}/app_s3_bucket_policy.json")
  vars = {
    bucket = aws_s3_bucket.app_s3_bucket.arn
  }
}

output "bucket_policy_output" {
  value = data.template_file.bucket_policy.rendered
}

resource "aws_s3_bucket" "artifacts_s3_bucket" {
  bucket = var.artifacts_bucket_name
  acl    = "public-read"
    
  tags = {
    Name = "Bucket containing app artifacts"
  }
}

resource "aws_s3_bucket_public_access_block" "app_s3_bucket_public_access" {
  bucket = aws_s3_bucket.app_s3_bucket.id

  block_public_acls   = false
  block_public_policy = false
}

resource "aws_s3_bucket" "app_s3_bucket" {
  bucket = var.app_bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
  }

  tags = {
    Name = "Bucket containing production app"
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.app_s3_bucket.id
  policy = data.template_file.bucket_policy.rendered
}

locals {
  s3_origin_id = "react-redux-realworld-example-app-S3-origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.app_s3_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
  }

 default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 60
    max_ttl                = 86400
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
