resource "aws_ecr_repository" "web_server_repo" {
  name                 = "${var.app_name}/web-server"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.app_name}-web-server-repo"
  }
}
