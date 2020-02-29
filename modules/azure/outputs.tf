output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "network_address" {
  value = "${azurerm_public_ip.public_ip.ip_address}:8080"
}