resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  private_cluster_enabled = var.private_cluster_enabled

  default_node_pool {
    name                = var.node_pool_name
    vm_size             = var.vm_size
    availability_zones  = var.availability_zones
    vnet_subnet_id      = var.vnet_subnet_id
    enable_auto_scaling = var.enable_auto_scaling
    node_count          = var.node_count
    min_count           = var.min_count
    max_count           = var.max_count


    tags = var.tags
  }

  automatic_channel_upgrade       = var.automatic_channel_upgrade
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  identity {
    type = "SystemAssigned"
  }

  dynamic "network_profile" {
    for_each = var.network_profile != null ? [var.network_profile] : []
    iterator = p
    content {
      docker_bridge_cidr = p.value.docker_bridge_cidr
      dns_service_ip     = p.value.dns_service_ip
      network_plugin     = p.value.network_plugin
      outbound_type      = p.value.outbound_type
      service_cidr       = p.value.service_cidr
    }
  }

  tags = var.tags
}