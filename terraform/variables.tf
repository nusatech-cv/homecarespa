variable "ssh_user" {
  type        = string
  description = "Name of the SSH user to use"
}

variable "ssh_password" {
  type        = string
  description = "SSH password"
  sensitive   = true
}

variable "host_ip" {
  type        = string
  description = "The IP address of the host"
}