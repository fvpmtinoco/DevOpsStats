locals {
    resource_group_name = "rabbitmq-resource-group"
    location            = "West Europe"
}

terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 4.10.0" # Specifies the AzureRM provider version
        }
    }
}

# Create Log Analytics Workspace (Required for Container Apps)
resource "azurerm_log_analytics_workspace" "rabbitmq_log_analytics" {
  name                = "rabbitmq-log-analytics" # Workspace name
  location            = local.location  
  resource_group_name = local.resource_group_name
  sku                 = "PerGB2018" # Pay-as-you-go pricing model
  retention_in_days   = 30 # Retain logs for 30 days
}

# Create Container Apps Environment
resource "azurerm_container_app_environment" "rabbitmq_env" {
  name                = "rabbitmq-container-env" # Environment name for container apps
  location            = local.location  
  resource_group_name = local.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.rabbitmq_log_analytics.id # Connect to Log Analytics
}

# Create RabbitMQ Container App
resource "azurerm_container_app" "rabbitmq" {
    name                          = "rabbitmq-app" # Name of the container app
    resource_group_name           = local.resource_group_name
    container_app_environment_id  = azurerm_container_app_environment.rabbitmq_env.id
    revision_mode                 = "Single" # Use a single revision for the app
    template {
        revision_suffix = "rabbitmq-v1" # Appends a suffix to the revision
        container {
            name   = "rabbitmq" # Name of the container
            image  = "rabbitmq:4.0.3-management" # RabbitMQ image with management plugin
            cpu    = 0.5 # Allocated CPU
            memory = "1.0Gi" # Allocated memory
            env {
                name  = "RABBITMQ_DEFAULT_USER" # Default RabbitMQ username
                value = var.rabbitmq_default_user
            }
            env {
                name  = "RABBITMQ_DEFAULT_PASS" # Default RabbitMQ password
                value = var.rabbitmq_default_pass
            }
        }
    }
    ingress {
        external_enabled   = true # Enable external ingress
        target_port        = 15672 # RabbitMQ management UI port
        transport          = "http" # HTTP transport protocol for the app
        traffic_weight {
        latest_revision = true # Use the latest app revision for traffic
        percentage      = 100 # 100% of traffic is routed to this revision
        }
    }
}

# Output the RabbitMQ Container App URL
output "rabbitmq_url" {
    value = azurerm_container_app.rabbitmq.ingress[0].fqdn # Outputs the app's fully qualified domain name
}
