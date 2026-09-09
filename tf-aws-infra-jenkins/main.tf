terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

#================================================================================================
# SECURITY GROUP INSTANCE
#================================================================================================
resource "aws_security_group" "security_group_instance_test" {
  name        = "jenkins-instance"
  description = "Utilizado na instancia do Jenkins"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = length(var.allowed_cidrs) > 0 ? var.allowed_cidrs : ["${chomp(data.http.myip.response_body)}/32"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#================================================================================================
# KEY PAIR
#================================================================================================
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

resource "null_resource" "generate_key_pair" {
  triggers = {
    key_name = var.key_name
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.example.private_key_pem}' > ./'${self.triggers.key_name}'.pem
      chmod 400 ./'${self.triggers.key_name}'.pem
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f '${self.triggers.key_name}'.pem"
  }

  depends_on = [aws_key_pair.generated_key]
}
##================================================================================================
# INSTÂNCIA EC2
#================================================================================================
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.generated_key.key_name
  vpc_security_group_ids      = [aws_security_group.security_group_instance_test.id]
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    dockerhub_username_base64     = base64encode(var.dockerhub_username)
    dockerhub_token_base64        = base64encode(var.dockerhub_token)
    github_ssh_private_key_base64 = var.github_ssh_private_key_base64
    jenkins_admin_password_base64 = base64encode(var.jenkins_admin_password)
    github_repository_base64      = base64encode(var.github_repository)
    jenkins_dockerfile_base64     = base64encode(file("${path.module}/jenkins/Dockerfile"))
    jenkins_bootstrap_base64      = base64encode(file("${path.module}/jenkins/bootstrap.groovy"))
  })

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = "1"
    http_endpoint               = "enabled"

  }

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.volume_size
    volume_type = var.volume_type
  }
  tags = var.tags
}