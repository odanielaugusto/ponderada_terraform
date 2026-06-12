output "ami_id" {
  description = "AMI Ubuntu usada na EC2."
  value       = data.aws_ami.ubuntu.id
}

output "instance_id" {
  description = "ID da instancia EC2 criada."
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "IP publico da instancia EC2."
  value       = aws_instance.app_server.public_ip
}

output "web_url" {
  description = "URL para validar o Nginx instalado via user_data."
  value       = "http://${aws_instance.app_server.public_ip}"
}

output "vpc_id" {
  description = "ID da VPC criada."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID da subnet publica."
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID do Security Group da aplicacao."
  value       = aws_security_group.web.id
}
