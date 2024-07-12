module "application-server" {
  source = "./application-server"

  ami-id = var.ami-id # AMI for an Amazon Linux instance for region: us-east-1

  iam-instance-profile = aws_iam_instance_profile.nodejs-web-app.id
  key-pair = aws_key_pair.nodejs-web-app-key.key_name
  name = "nodejs Web App"
  device-index = 0
  network-interface-id = aws_network_interface.nodejs-web-app.id
  repository-url = "repo URL"
}