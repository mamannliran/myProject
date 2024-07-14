resource "aws_secretsmanager_secret" "nodejs-web-app" {
  name = "nodejs-web-app13"
}

resource "aws_secretsmanager_secret_version" "nodejs-web-app" {
  secret_id = aws_secretsmanager_secret.nodejs-web-app.id
  secret_string = jsonencode(var.secrets)
}