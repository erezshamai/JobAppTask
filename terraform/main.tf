provider "azurerm" {
  features {}
  subscription_id = "2fa0e512-f70e-430f-9186-1b06543a848e"
}

resource "azurerm_resource_group" "devops" {
  name     = "Erez1-Candidate"
  location = "West Europe"
}

# Create the Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                     = "erezcontainerregistry"
  resource_group_name      = azurerm_resource_group.devops.name
  location                 = azurerm_resource_group.devops.location
  sku                       = "Basic"  
  admin_enabled            = true  # Enable admin access (optional)
}

# Create the virtual network (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name
}

# Create the dedicated subnet for AKS
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.devops.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#associate a Network Security Group (NSG) with the subnet
resource "azurerm_network_security_group" "nsg" {
  name                = "aks-nsg"
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "203.0.113.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowKubernetesAPI"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "203.0.113.0/24"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "aks_subnet_nsg" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = "tfstateerez"
  resource_group_name      = azurerm_resource_group.devops.name
  location                 = azurerm_resource_group.devops.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_key_vault" "kv" {
  name                        = "erez-akskv"
  location                    = azurerm_resource_group.devops.location
  resource_group_name         = azurerm_resource_group.devops.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.devops.location
  resource_group_name = azurerm_resource_group.devops.name
  dns_prefix          = "akscluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    admin_group_object_ids = ["147084b4-5625-4f92-afd9-e90ce49064e2"]
  }

  role_based_access_control_enabled = true

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
  }

  api_server_access_profile {
    authorized_ip_ranges = ["203.0.113.0/24"]
  }
}

resource "azurerm_key_vault_access_policy" "aks_access_policy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

data "azurerm_client_config" "current" {}
