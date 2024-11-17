variable "environment" {
  description = "The environment to deploy (e.g., dev, staging, prod)"
  type        = string
}

variable "subscription_id" {
    description = "The Azure subscription ID"
    type        = string
}

variable "rabbitmq_default_user" {
    description = "The RabbitMQ default user"
    type        = string
    default     = "admin"
}

variable "rabbitmq_default_pass" {
    description = "The RabbitMQ default password"
    type        = string
    sensitive   = true
}