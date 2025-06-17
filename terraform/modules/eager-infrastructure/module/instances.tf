resource "aws_key_pair" "deployer" {
  key_name   = "${var.app_name}-deployer-key"
  public_key = file(var.deployer_key)
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app_servers" {
  for_each = tomap({
    for i in range(var.servers_count) : i => {
      subnet_id = i % 2 == 0 ? aws_subnet.private_subnet_1.id : aws_subnet.private_subnet_2.id
    }
  })

  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  subnet_id       = each.value.subnet_id
  security_groups = [aws_security_group.web_server_sg.id]
  key_name        = aws_key_pair.deployer.key_name

  tags = {
    Name = "${var.app_name}-web-server-${each.key}"
  }

  user_data = file("${path.module}/scripts/user_data.sh")
}

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  security_groups             = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name

  tags = {
    Name = "${var.app_name}-bastion"
  }
}
