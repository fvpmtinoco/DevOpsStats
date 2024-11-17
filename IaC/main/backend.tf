terraform {
    backend "azurerm" {
        resource_group_name  = "rabbitmq-resource-group"
        storage_account_name = "rabbitmqtfstate"
        container_name       = "tfstate"
        key                  = "terraform.state"
    }
}

provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
}