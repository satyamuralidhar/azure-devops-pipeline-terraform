terraform {
  required_providers {
    azurerm = {
        version = "~>3.0.0"
        source = "hashicorp/azurerm"
    }
  }
}

terraform {
  backend "azurerm" {}
}

provider "azurerm" {
    features {}
}

locals {
    vnet = "192.168.0.0/16"
    subnet1 = "192.168.1.0/24"
    subnet2 = "192.168.2.0/24"

}

variable "resource_group_name" {}

variable "resource_group_location" {}


resource "azurerm_resource_group" "myrsg" {
  name = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_resource_group_template_deployment" "template" {
  name = "my-vnet-template"
  resource_group_name = azurerm_resource_group.myrsg.name
  deployment_mode = "Incremental"
  template_content = file("${path.module}/vnet.json")
  parameters_content = jsonencode({
    "myvnet" = {
        value = local.vnet
    },
    "mysubnet-1" = {
        value = local.subnet1
    },
    "mysubnet-2" = {
        value = local.subnet2
    }
  })
}