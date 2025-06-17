output "web_servers_ip_addr" {
  value = {
    for server in aws_instance.app_servers :
    server.id => server.private_ip
  }
}

output "bastion_ip_addr" {
  value = aws_instance.bastion_host.public_ip
}

output "container_registry_url" {
  value = aws_ecr_repository.web_server_repo.repository_url
}
