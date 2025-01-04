output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id, aws_subnet.private_1.id, aws_subnet.private_2.id]
}

output "security_group" {
  description = "Control plane security group"
  value       = aws_security_group.control_plane.id
}

# Output para mostrar la IP pública de la instancia Bastion
output "ec2_public_ip" {
  description = "Public IP address of the Bastion instance"
  value       = aws_instance.bastion.public_ip
}

# Output para mostrar el ARN del rol de IAM de la instancia Bastion
output "bastion_role_arn" {
  description = "ARN of the Bastion IAM Role"
  value       = aws_iam_role.bastion_role.arn
}
