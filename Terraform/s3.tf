# S3 Bucket storing logs

resource "aws_s3_bucket" "nodejs-web-app-logs" {
  bucket = "liran12-nodejs-web-app-logs"
  acl = "private"
}

# S3 Bucket storing jenkins user data

resource "aws_s3_bucket" "jenkins-config" {
  bucket = "liran12-jenkins-config"
  acl = "private"
}

resource "aws_s3_object" "jenkins-config" {
  bucket = aws_s3_bucket.jenkins-config.id
  for_each = fileset("jenkins-config/", "*")
  key = each.value
  source = "jenkins-config/${each.value}"
  etag = filemd5("jenkins-config/${each.value}")
}