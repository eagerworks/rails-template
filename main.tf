terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = "us-east-1"
}

# ==== Variables ====

variable "deployer_key" {
  description = "SSH public key for the deployer"
  type        = string
}

variable "app_name" {
  description = "Name of the Rails application. This will be used for naming resources."
  type        = string
}

variable "rails_master_key" {
  description = "Master key for Rails application"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database user"
  type        = string
  sensitive   = true
}

variable "dns_name" {
  description = "DNS name for the application"
  type        = string
}

variable "site_url" {
  description = "Site URL for the application"
  type        = string
}

variable "aws_profile" {
  description = "AWS profile to use for the deployment"
  type        = string
}

resource "aws_secretsmanager_secret" "rails_secrets" {
  name                    = "${var.app_name}/web_server_secrets"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secrets" {
  secret_id = aws_secretsmanager_secret.rails_secrets.id
  secret_string = jsonencode(
    {
      RAILS_MASTER_KEY = var.rails_master_key,
      RDS_HOST         = aws_db_instance.db_instance.address
      RDS_PASSWORD     = var.db_password
    }
  )
}

# ===== VPC Configuration =====

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_eip" "nat_ip" {
  domain = "vpc"
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.app_name}-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.app_name}-private-subnet-2"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.app_name}-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.app_name}-public-subnet-2"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.public_subnet_1.id
  allocation_id = aws_eip.nat_ip.id

  tags = {
    Name = "${var.app_name} gw NAT"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-internet-gateway"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_1_assoc" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_2_assoc" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

# ===== EC2 Configuration =====

resource "aws_key_pair" "deployer" {
  key_name   = "${var.app_name}-deployer-key"
  public_key = var.deployer_key
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "app_server" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.private_subnet_1.id
  security_groups = [aws_security_group.web_server_sg.id]
  key_name        = aws_key_pair.deployer.key_name

  tags = {
    Name = "${var.app_name}-web-server"
  }
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

resource "aws_lb" "app_load_balancer" {
  name               = "${var.app_name}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
  security_groups = [aws_security_group.lb_sg.id]
}

resource "aws_lb_target_group" "web_server_tg" {
  name     = "${var.app_name}-web-server"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "web_server_listener" {
  load_balancer_arn = aws_lb.app_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.lb_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_server_tg.arn
  }

  depends_on = [aws_route53_record.acm_validation]
}

resource "aws_lb_target_group_attachment" "web_server_attachment" {
  target_group_arn = aws_lb_target_group.web_server_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 80
}

# ===== DNS Configuration =====

data "aws_route53_zone" "main" {
  name = var.dns_name
}

resource "aws_route53_record" "app_dns" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.site_url
  type    = "A"

  alias {
    name                   = aws_lb.app_load_balancer.dns_name
    zone_id                = aws_lb.app_load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.lb_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 3600
}

resource "aws_acm_certificate" "lb_cert" {
  domain_name       = var.site_url
  validation_method = "DNS"

  validation_option {
    domain_name       = var.site_url
    validation_domain = var.dns_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ===== RDS Configuration =====

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.app_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "${var.app_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "db_instance" {
  identifier             = "${var.app_name}-db"
  engine                 = "postgres"
  engine_version         = "17.5"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  username               = "postgres"
  password               = var.db_password
  skip_final_snapshot    = true

  tags = {
    Name = "${var.app_name}-db-instance"
  }
}

# ===== Security Groups =====

resource "aws_security_group" "bastion_sg" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "${var.app_name}-bastion-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.private_subnet_1.cidr_block, aws_subnet.private_subnet_2.cidr_block]
  }
}

resource "aws_security_group" "web_server_sg" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "${var.app_name}-web-server-sg-"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "lb_sg" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "${var.app_name}-lb-sg-"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_subnet_1.cidr_block, aws_subnet.private_subnet_2.cidr_block]
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "${var.app_name}-db-sg-"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ===== ECR Configuration =====

resource "aws_ecr_repository" "web_server_repo" {
  name                 = "${var.app_name}/web-server"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "RailsTemplateRepo"
  }
}

# ===== Outputs =====

output "web_server_ip_addr" {
  value = aws_instance.app_server.private_ip
}

output "bastion_ip_addr" {
  value = aws_instance.bastion_host.public_ip
}

output "container_registry_url" {
  value = aws_ecr_repository.web_server_repo.repository_url
}
