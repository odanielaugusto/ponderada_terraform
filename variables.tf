variable "aws_region" {
  description = "Regiao AWS usada no provisionamento."
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Nome base usado em tags e recursos."
  type        = string
  default     = "ponderada-terraform"
}

variable "environment" {
  description = "Ambiente da entrega."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "homolog", "prod"], var.environment)
    error_message = "Use um dos ambientes: dev, homolog ou prod."
  }
}

variable "owner" {
  description = "Responsavel pelos recursos."
  type        = string
  default     = "Daniel Augusto"
}

variable "vpc_cidr_block" {
  description = "Bloco CIDR da VPC."
  type        = string
  default     = "10.42.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr_block, 0))
    error_message = "Informe um CIDR valido para a VPC."
  }
}

variable "public_subnet_cidr_block" {
  description = "Bloco CIDR da subnet publica."
  type        = string
  default     = "10.42.1.0/24"

  validation {
    condition     = can(cidrhost(var.public_subnet_cidr_block, 0))
    error_message = "Informe um CIDR valido para a subnet publica."
  }
}

variable "instance_type" {
  description = "Tipo da instancia EC2. O padrao acompanha o free tier usado no tutorial."
  type        = string
  default     = "t2.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR liberado para SSH. Deixe vazio para nao expor a porta 22."
  type        = string
  default     = ""

  validation {
    condition     = var.allowed_ssh_cidr == "" || can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "Informe um CIDR valido, como 203.0.113.10/32, ou deixe vazio."
  }
}
