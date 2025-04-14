data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = false
  sku_name                   = "premium"
  soft_delete_retention_days = 7
  enable_rbac_authorization = false  # Using access policies instead of RBAC
}

# Access policy for pipeline service principal
resource "azurerm_key_vault_access_policy" "pipeline_sp" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "716e41b0-17ef-4e4a-844a-f4d25cbda1f1"  # Pipeline SP object ID

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Purge"
  ]
}

# Access policy for created service principal
resource "azurerm_key_vault_access_policy" "created_sp" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.service_principal_tenant_id
  object_id    = var.service_principal_object_id

  secret_permissions = [
    "Get", "List"
  ]
}

