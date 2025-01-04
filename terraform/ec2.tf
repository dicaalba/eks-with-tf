# ec2_bastion.tf

# Generación del par de claves SSH (se usará la clave pública proporcionada)
resource "aws_key_pair" "bastion_key" {
  key_name   = var.key_name  # El nombre del par de claves (pasado como variable)
  public_key = var.public_key_material  # La clave pública (pasada como variable)
}

# Security Group para la instancia Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for Bastion Host"
  vpc_id      = aws_vpc.main.id

  # Acceso SSH desde cualquier lugar (puedes restringir a una IP para mayor seguridad)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Acceso a puerto 8080, si se requiere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permitir tráfico saliente a cualquier destino
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Crear el rol de IAM para la instancia Bastion
resource "aws_iam_role" "bastion_role" {
  name               = "bastion-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      },
    ]
  })

  # Políticas necesarias para interactuar con EKS y ECR
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}

# Crear el perfil de instancia (instance profile) para la instancia EC2
resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "bastion-instance-profile"
  role = aws_iam_role.bastion_role.name
}

# Instancia Bastion EC2
resource "aws_instance" "bastion" {
  ami                    = var.ami_id  # AMI ID (pasado como variable)
  instance_type           = var.instance_type  # Tipo de instancia (pasado como variable)
  key_name               = aws_key_pair.bastion_key.key_name  # Usamos el par de claves generado
  security_groups        = [aws_security_group.bastion_sg.name]  # Asociamos el Security Group
  iam_instance_profile   = aws_iam_instance_profile.bastion_instance_profile.name  # Perfil IAM para permisos
  associate_public_ip_address = true  # Asignar IP pública

  tags = {
    Name = "Bastion Server"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Instalar kubectl
              curl -LO https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl
              chmod +x ./kubectl
              mv ./kubectl /usr/local/bin/kubectl

              # Instalar aws-cli
              yum install -y aws-cli
              EOF
}
