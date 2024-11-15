variable "allowed_ports" {
  description = "Lista de portas a serem abertas para o grupo de seguranca"
  type        = list(number)
  default     = [22, 8080, 8001, 8000, 9000]
}

variable "allowed_cidrs" {
  description = "Lista de cidrs a serem abertos para o grupo de seguranca"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "Id da VPC"
  type        = string
  default     = "vpc-99580efd"
}

variable "key_name" {
  description = "Nome da chave .pem"
  type        = string
  default     = "jenkins"
}

variable "instance_type" {
  description = "Tipo da instancia"
  type        = string
  default     = "t3a.large"
}

variable "subnet_id" {
  description = "Id da subnet"
  type        = string
  default     = "subnet-9a4d84fd"
}

variable "volume_size" {
  description = "Tamanho do disco"
  type        = number
  default     = 30
}

variable "volume_type" {
  description = "Tipo do disco"
  type        = string
  default     = "gp3"
}

variable "tags" {
  description = "Tags que podem ser utilizada para ideificar o recurso"
  type        = map(string)
  default = {
    "Name" = "Jenkins"
  }
}