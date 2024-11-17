provider "azurerm" {
    subscription_id = var.subscription_id # Subscription ID passed as a variable
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
            }
        }
}

# Create Resource Group
resource "azurerm_resource_group" "rabbitmq_rg" {
    name     = "rabbitmq-resource-group"
    location = "West Europe" # Location for the resource group
    # Prevent the Resource Group from being destroyed
    # lifecycle {
    #     prevent_destroy = true
    # } 
}

# Create Storage Account for Terraform State
resource "azurerm_storage_account" "rabbitmq_storage" {
    name                     = "rabbitmqtfstate" # Must be globally unique
    resource_group_name      = azurerm_resource_group.rabbitmq_rg.name
    location                 = azurerm_resource_group.rabbitmq_rg.location
    account_tier             = "Standard" # Standard performance tier
    account_replication_type = "LRS" # Locally redundant storage
    # Prevent the Storage Account from being destroyed
    # lifecycle {
    #     prevent_destroy = true
    # }
}

# Create a Blob Container for Terraform State
resource "azurerm_storage_container" "tfstate" {
    name                  = "tfstate" # Container name for the state file
    storage_account_id  = azurerm_storage_account.rabbitmq_storage.id
    container_access_type = "private" # Access is restricted to the account owner
      # Prevent the Blob Container from being destroyed
    # lifecycle {
    #     prevent_destroy = true
    # }
}