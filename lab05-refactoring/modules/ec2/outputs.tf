output "public_ip" {
  value = aws_instance.example.public_ip
  description = "Endereço IP público da instância EC2"
}