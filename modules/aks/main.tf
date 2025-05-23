# Retrieve latest AKS version for the specified location
data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
  include_preview = false  
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name = var.cluster_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  dns_prefix            = "${var.resource_group_name}-cluster"           
  kubernetes_version    = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-nrg"
  
  default_node_pool {
    name       = var.node_pool_name
    vm_size    = "Standard_B2ms" 
    auto_scaling_enabled = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"

  }

  service_principal  {
    client_id = var.client_id
    client_secret = var.client_secret
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
        key_data = tls_private_key.ssh.public_key_openssh
    }
  }

  network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
  }

    
  }

# SSH key for cluster access
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


