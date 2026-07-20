# LAB 03: Provisionamento na AWS (Nuvem Real vs. Emulação Local)

Este laboratório prático guiará você no provisionamento do seu primeiro servidor web (`EC2`) e grupo de segurança (`Security Group`) na AWS, utilizando uma estratégia híbrida: rodando diretamente na **nuvem da AWS** ou emulado localmente via **LocalStack** no **GitHub Codespaces**.

---

## 🎯 Objetivos de Aprendizado
- Provisionar recursos básicos de infraestrutura AWS (`aws_instance` e `aws_security_group`).
- Entender como chavear provedores no Terraform para diferentes ambientes.
- Emular e testar infraestruturas de nuvem localmente para desenvolvimento rápido.

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 0: Instalação do Terraform (Caso necessário)
Caso o comando `terraform` não esteja disponível no terminal do seu Codespaces, execute os comandos abaixo para instalá-lo rapidamente:
```bash
wget https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip
unzip terraform_1.9.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_1.9.0_linux_amd64.zip
```

### Passo 0.1: Instalação do AWS CLI (Opcional)
Se você deseja interagir com os recursos diretamente pela linha de comando da AWS no seu terminal (como validar se as instâncias subiram), execute o comando abaixo para instalar o `AWS CLI v2`:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/
```
*(Nota: Esta etapa é totalmente opcional. O Terraform não necessita do AWS CLI instalado para funcionar, pois utiliza chamadas nativas de API).*

### Passo 1: Preparação do Ambiente (Escolha uma opção)

Selecione a opção baseada no status de disponibilidade do seu ambiente da AWS:

#### 🟢 Opção A: Utilizando a AWS Real (AWS Academy)
Se você já possui as credenciais de acesso temporário da AWS Academy:

1. No console da AWS Academy, copie as credenciais temporárias fornecidas em **AWS Details** -> **AWS CLI**.
2. No seu Codespaces, crie a pasta de configuração da AWS (caso não exista) e abra o arquivo de credenciais:
   ```bash
   mkdir -p ~/.aws && code ~/.aws/credentials
   ```
3. No editor que se abriu, cole as chaves estruturadas no formato abaixo (removendo os comandos `export` e as aspas da cópia anterior):
   ```ini
   [default]
   aws_access_key_id = SUA_ACCESS_KEY_ID
   aws_secret_access_key = SUA_SECRET_ACCESS_KEY
   aws_session_token = SEU_SESSION_TOKEN
   ```
4. Salve o arquivo (`Ctrl + S`).

#### 🟡 Opção B: Utilizando a AWS Emulada (LocalStack)
Se você NÃO possui credenciais AWS ativas no momento:
1. No terminal do seu Codespaces, execute o comando abaixo para iniciar o emulador de nuvem em background via Docker:
   ```bash
   docker run -d --name localstack -p 4566:4566 -p 4571:4571 localstack/localstack
   ```
2. Confirme que o emulador está rodando executando `docker ps`.

---

### Passo 2: Configurar o Provedor no `main.tf`
1. No gerenciador de arquivos esquerdo do Codespaces, expanda a pasta `lab03-simple_aws_ec2` e abra o arquivo `main.tf`.
2. Configure o bloco do `provider "aws"` de acordo com a opção escolhida no Passo 1:

- **Se escolheu a Opção A (AWS Real):** Mantenha a configuração padrão do arquivo:
  ```hcl
  provider "aws" {
    region = "us-east-1"
  }
  ```

- **Se escolheu a Opção B (LocalStack):** Comente a configuração padrão e descomente a configuração do LocalStack (se as linhas não existirem, insira o seguinte bloco do provedor):
  ```hcl
  provider "aws" {
    region                      = "us-east-1"
    access_key                  = "mock"
    secret_key                  = "mock"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    
    endpoints {
      ec2      = "http://localhost:4566"
      s3       = "http://localhost:4566"
      dynamodb = "http://localhost:4566"
    }
  }
  ```

---

### Passo 3: Executar os Comandos do Terraform
No terminal do seu Codespaces, execute os comandos do ciclo de vida:

1. **Navegar para a pasta do Lab 03:**
   ```bash
   cd lab03-simple_aws_ec2
   ```

2. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```

3. **Verificar o Planejamento:**
   ```bash
   terraform plan
   ```
   *Note que o Terraform indicará que planeja criar 2 novos recursos: a instância EC2 (`aws_instance.example`) e o grupo de segurança (`aws_security_group.allow_ssh_http`).*

4. **Aplicar o Provisionamento:**
   ```bash
   terraform apply
   ```
   *Digite **`yes`** e aperte `Enter` para confirmar.*

---

## 🔍 Pontos de Validação Prática

- **Validação Visual (Sem AWS CLI):**
  * **AWS Real (Opção A):** Verifique a instância "Terraform Example" no console web da AWS EC2.
  * **LocalStack (Opção B):** Inspecione o arquivo local `terraform.tfstate`.

- **Validação via Terminal (Apenas se você instalou o AWS CLI no Passo 0.1):**
  * **AWS Real (Opção A):**
    ```bash
    aws ec2 describe-instances --query "Reservations[*].Instances[*].{ID:InstanceId,State:State.Name,Name:Tags[?Key=='Name'].Value|[0]}" --output table
    ```
  * **LocalStack (Opção B):**
    ```bash
    aws --endpoint-url=http://localhost:4566 ec2 describe-instances --query "Reservations[*].Instances[*].{ID:InstanceId,State:State.Name,Name:Tags[?Key=='Name'].Value|[0]}" --output table
    ```

---

## 🧹 Limpeza do Ambiente
Para evitar cobranças (na AWS real) ou liberar recursos locais (no Docker), execute no terminal do laboratório:
```bash
terraform destroy
```
*Digite **`yes`** e confirme a destruição. Verifique que a instância e o grupo de segurança foram removidos.*
