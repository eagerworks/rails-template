resource "aws_secretsmanager_secret" "app_secrets" {
  name                    = "${var.app_name}/web_server_secrets"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secrets" {
  secret_id = aws_secretsmanager_secret.app_secrets.id
  secret_string = jsonencode(
    merge(
      var.app_secrets,
      {
        RDS_HOST     = aws_db_instance.db_instance.address,
        RDS_PASSWORD = var.db_password
      }
    )
  )
}
