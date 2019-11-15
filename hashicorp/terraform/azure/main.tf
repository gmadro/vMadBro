provider "azurem" {
    version = "=1.36.0"
}

resource "azurerm_resource_group" "res_group" {
    name = "terraform"
    location = "East US"
}

resource "azurerm_storage_account" "storage_acc" {
    name = "terraformStorage"
    location = "${azurerm_resource_group.Terrafrom.location}"
    resource_group_name = "${azurerm_resource_group.res_group.name}"
    account_tier = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "app_plan" {
    name = "terraform-app-service-plan"
    location = "${azurerm_resource_group.Terrafrom.location}"
    resource_group_name = "${azurerm_resource_group.res_group.name}"
    kind = "FunctionApp"

    sku {
        tier = "Dynamic"
        size = "Y1"
    }
}

resource "azurerm_function_app" {
    name = "terraform"
    location = "${azurerm_resource_group.res_group.location}"
    resource_group_name = "${azurerm_resource_group.res_group.name}"
    app_service_plan_id = "${azurem_app_service_plan}"
    storage_connection_string = "${azurerm_storage_account.storage_acc.primary_connection_string}"
}