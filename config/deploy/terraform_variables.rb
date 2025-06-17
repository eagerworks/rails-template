# Extract variables from terraform to use in kamal deploy config

def terraform_output(name)
  JSON.parse(%x(cd terraform/production && terraform output -json #{name}))
end

def web_server_ips
  terraform_output('web_servers_ip_addr').values
end

def bastion_ip
  terraform_output('bastion_ip_addr')
end

def ecr
  terraform_output('container_registry_url').split('/')[0]
end
