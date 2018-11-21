provider "aws" {
  access_key  = "${var.aws_access_key_id}"
  secret_key  = "${var.aws_secret_access_key}"
  region = "${var.aws_region}"
}

resource "aws_instance" "windows" {
  ami = "ami-050202fb72f001b47"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.ec2.id}"]
  key_name = "${var.key_name}"
  availability_zone = "${var.AZ}"
  associate_public_ip_address = true
  subnet_id = "${var.ec2_subnet_id}"
  user_data = <<EOF
   <powershell>
   
   get-windowsfeature | where{$_.name -match "web-server"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-scripting-tools"} | add-windowsfeature  
   get-windowsfeature | where{$_.name -match "web-net-ext45"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-asp-net45"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-isapi-ext"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-isapi-filter"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-default-doc"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-dir-browsing"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-http-errors"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-http-redirect"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-static-content"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-http-logging"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-log-libraries"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-http-tracing"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-basic-auth"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-digest-auth"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-filtering"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-url-auth"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-windows-auth"} | add-windowsfeature
   get-windowsfeature | where{$_.name -match "web-mgmt-console"} | add-windowsfeature
   
   </powershell>
EOF
  tags {
    Name = "${var.name_tags}-EC2"
  }
}

resource "aws_security_group" "ec2" {
  name = "${var.name_tags}-EC2-SG"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = "3389"
    to_port = "3389"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "443"
    to_port = "443"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "alb" {
  name = "${var.name_tags}-ALB-SG"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.name_tags}-ALB-SG"
  
  }
}


resource "aws_alb" "LoadBalancer" {
  name = "${var.name_tags}-ALB"
  internal = false
  idle_timeout = "300"
  security_groups = [
    "${aws_security_group.alb.id}"
  ]
  subnets = ["${var.alb_public_subnet1_id}", "${var.alb_public_subnet2_id}"] 
  tags {
    Name = "${var.name_tags}-ALB"
  }
}

resource "aws_alb_listener" "Listner1" {
  load_balancer_arn = "${aws_alb.LoadBalancer.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.CertARN}"

  default_action {
    target_group_arn = "${aws_alb_target_group.TargetGroup.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "Listner2" {
  load_balancer_arn = "${aws_alb.LoadBalancer.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.TargetGroup.arn}"
    type             = "forward"
  }
}


resource "aws_alb_target_group" "TargetGroup" {
  name     = "${var.name_tags}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  tags {
    Name = "${var.name_tags}-TG"
  }
}

resource "aws_alb_target_group_attachment" "Registration" {
  target_group_arn = "${aws_alb_target_group.TargetGroup.arn}"
  target_id = "${aws_instance.windows.id}"
  port = 80
}
