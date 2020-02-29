output "public_ip" {
  value = aws_instance.instance.public_ip
}

output "network_address" {
  value = "${aws_instance.instance.public_ip}:8080"
}