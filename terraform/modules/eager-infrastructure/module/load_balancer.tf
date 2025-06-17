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
  for_each = aws_instance.app_servers

  target_group_arn = aws_lb_target_group.web_server_tg.arn
  target_id        = each.value.id
  port             = 80
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
