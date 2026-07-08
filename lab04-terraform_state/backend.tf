terraform {
  backend "s3" {
    bucket         = "terraform-state-rafael-matsuyama123"  # Usar o nome do bucket criado pelo Terraform
    key            = "terraform.tfstate" # Nome do arquivo de estado
    region         = "us-east-1"      # Substitua pela sua região
    dynamodb_table = "terraform-locks" # Usar o nome da tabela DynamoDB criada pelo Terraform
    encrypt        = true             # Habilitar a criptografia do State no S3
  }
}