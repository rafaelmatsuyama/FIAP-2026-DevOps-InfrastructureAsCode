# LAB 06: Consultas Dinâmicas (Uso de Data Sources no Terraform)

Este laboratório prático guiará você no uso de **Data Sources** (fontes de dados) no Terraform. Em vez de declarar valores estáticos e "chumbados" no código (como IDs de imagens AMI que mudam constantemente e expiram), você aprenderá a consultar dinamicamente as informações atualizadas diretamente da API da AWS. Este laboratório será executado diretamente na **AWS Real** (AWS Academy).

---

## 🎯 Objetivos de Aprendizado
- Compreender a diferença conceitual entre recursos (`resource`) e fontes de dados (`data`).
- Configurar filtros avançados para pesquisar recursos existentes na nuvem.
- Consultar dinamicamente a AMI oficial do Ubuntu 20.04 mais recente direto da Canonical.
- Provisionar uma instância EC2 utilizando a AMI obtida dinamicamente.

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Preparação do Ambiente
1. Certifique-se de que suas credenciais temporárias da AWS Academy estão configuradas e ativas no arquivo `~/.aws/credentials`.

---

### Passo 2: Analisar a Estrutura de Consulta no `main.tf`
Abra o arquivo `main.tf` na pasta `lab06-datasource/` e observe o bloco de `data`:

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # ID Oficial da Canonical na AWS
}
```

*Este bloco faz uma busca em tempo real na AWS filtrando por imagens cujo nome comece com a string do Ubuntu 20.04, tipo de virtualização `hvm`, de propriedade exclusiva do owner `099720109477` (Canonical) e retorna apenas o registro mais recente (`most_recent = true`).*

Observe também a referência à AMI no recurso da instância EC2:
```hcl
resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  
  tags = {
    Name = "Data Sources Example"
  }
}
```
*Em vez de colocar uma string de ID estática, vinculamos o dado dinâmico usando `data.aws_ami.ubuntu.id`.*

---

### Passo 3: Executar os Comandos do Terraform
No terminal do seu Codespaces, execute as etapas do ciclo de vida:

1. **Navegar para a pasta do Lab 06:**
   ```bash
   cd lab06-datasource
   ```
2. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```
3. **Verificar o Planejamento Dinâmico:**
   ```bash
   terraform plan
   ```
   > **Dica Visual:** No output do `terraform plan`, repare que o Terraform já exibe o ID real da AMI resolvida dinamicamente (ex: `ami-053b0d53c279acc90` ou similar), provando que a consulta à API da AWS foi feita com sucesso em background!
4. **Aplicar o Provisionamento:**
   ```bash
   terraform apply
   ```
   *Digite **`yes`** e aperte `Enter` para confirmar.*

---

## 🔍 Pontos de Validação Prática

1. **Validação do ID da AMI:**
   Após a conclusão do apply, acesse o Console da AWS EC2 e selecione a instância criada ("Data Sources Example"). Vá nos detalhes e confirme que a AMI utilizada coincide exatamente com a última imagem oficial do Ubuntu listada no planejamento do terminal.

---

## 🧹 Limpeza do Ambiente
Para evitar custos acumulados na sua conta de testes, remova a infraestrutura criada executando:
```bash
terraform destroy
```
*Digite **`yes`** para confirmar a destruição.*
