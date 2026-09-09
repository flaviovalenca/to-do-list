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
  default     = "vpc-085b8474997b3b2a2"
}

variable "key_name" {
  description = "Nome da chave .pem"
  type        = string
  default     = "jenkins"
}

variable "instance_type" {
  description = "Tipo da instancia"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Id da subnet"
  type        = string
  default     = "subnet-05dfd403c95b5ae79"
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

variable "dockerhub_username" {
  description = "Docker Hub username used by the Jenkins credential"
  type        = string
  sensitive   = true
}

variable "dockerhub_token" {
  description = "Docker Hub access token used by Jenkins"
  type        = string
  sensitive   = true
}

variable "github_ssh_private_key_base64" {
  description = "Base64-encoded private SSH key used by Jenkins to clone GitHub"
  type        = string
  sensitive   = true
}

variable "jenkins_admin_password" {
  description = "Initial Jenkins administrator password"
  type        = string
  sensitive   = true
}

variable "github_repository" {
  description = "Git repository used by the production Jenkins job"
  type        = string
  default     = "git@github.com:flaviovalenca/to-do-list.git"
}