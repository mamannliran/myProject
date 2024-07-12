# Production Repository

resource "aws_ecr_repository" "nodejs-web-app" {
  name = "nodejs-web-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Elastic Container Registry to store Docker Artifacts"
  }
}

# Staging Repository

resource "aws_ecr_repository" "nodejs-web-app-staging" {
  name = "nodejs-web-app-staging"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Elastic Container Registry to store Docker Artifacts"
  }
}

# Test Repository

resource "aws_ecr_repository" "nodejs-web-app-test" {
  name = "nodejs-web-app-test"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Elastic Container Registry to store Docker Artifacts"
  }
}