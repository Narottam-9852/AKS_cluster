terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.35.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "b397c2d0-369a-47dd-9100-9467b7447185"
}

resource "azurerm_resource_group" "rg" {
  name     = "narottam-resources"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "narottam-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_A2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure" # or "kubenet"
    network_policy    = "azure" # or "calico"
    load_balancer_sku = "standard"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

resource "azurerm_resource_group" "rg2" {
  name     = "narottam-resources2"
  location = "West Europe"
}
