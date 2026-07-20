# LAB 02: Provisionamento Local (Terraform + Docker no Codespaces)

Este laboratório prático guiará você no provisionamento de um servidor web real rodando em container utilizando o **Terraform** e o **Docker** integrados no ambiente do **GitHub Codespaces**.

---

## 🎯 Objetivos de Aprendizado
- Declarar e utilizar um provider externo (`kreuzwerker/docker`).
- Compreender a persistência de recursos reais provisionados (Containers).
- Analisar a estrutura do arquivo `terraform.tfstate` com recursos complexos.

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Abrir o Terminal do Codespaces
Certifique-se de que você está com o seu ambiente do Codespaces aberto no navegador e que limpou os recursos do Lab 01 (rodando `terraform destroy` no diretório anterior, se necessário).

### Passo 2: Criar o Arquivo de Configuração do Terraform
1. No seu Codespaces, clique com o botão direito sobre a subpasta **`lab02-docker_basics`**, selecionando **New File** (Novo Arquivo).
2. Crie um arquivo chamado **`main.tf`** dentro desta subpasta.
3. Cole o seguinte código HCL de configuração do Terraform:

```hcl
# 1. Definição do Provider do Docker
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

# Configuração vazia do provider (inicia com sockets locais do host/Codespaces)
provider "docker" {}

# 2. Recurso: Baixar a imagem do Nginx do Docker Hub
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# 3. Recurso: Provisionar e iniciar o container web
resource "docker_container" "nginx_web" {
  image = docker_image.nginx.image_id
  name  = "fiap-web-server"

  ports {
    internal = 80
    external = 8080
  }
}
```

### Passo 3: Inicializar e Provisionar a Infraestrutura
No terminal integrado do Codespaces, execute os comandos do ciclo de vida:

1.  **Navegação e Inicialização:**
    Primeiro, navegue para a pasta deste laboratório no terminal:
    ```bash
    cd lab02-docker_basics
    ```
    Depois, inicialize o provider do Docker:
    ```bash
    terraform init
    ```
    *Este comando baixará o plugin do Docker Provider da HashiCorp Registry.*

2.  **Planejamento:**
    ```bash
    terraform plan
    ```
    *O Terraform informará que planeja criar 2 recursos: a imagem do Docker e o container correspondente.*

3.  **Execução:**
    ```bash
    terraform apply
    ```
    *Digite **`yes`** para confirmar a execução.*

---

## 🔍 Pontos de Validação Prática

1.  **Validação via Docker CLI:** No terminal do Codespaces, execute o comando normal do Docker:
    ```bash
    docker ps
    ```
    *Note que o container chamado `fiap-web-server` está rodando e mapeando a porta 80 do container para a porta 8080 do Codespaces.*
2.  **Acesso Visual à Aplicação:** O VS Code/Codespaces detectará automaticamente o tráfego da porta `8080` e exibirá um pop-up no canto inferior direito informando que a porta foi encaminhada. Clique no botão **Open in Browser** (ou acesse a aba *Ports* no terminal e clique no ícone do globo ao lado da porta 8080).
    *Você verá a página clássica de boas-vindas: "Welcome to nginx!".*
3.  **Analise o State:** Abra o arquivo `terraform.tfstate`. Note que agora ele possui metadados complexos do container, como IPs internos, IDs de volumes e status da imagem.

---

## 🧹 Limpeza do Ambiente
Para desprovisionar o container e limpar a imagem criada, execute no terminal do Codespaces (garanta que está na pasta `lab02-docker_basics`):
```bash
terraform destroy
```
*Digite **`yes`** para confirmar. Verifique rodando `docker ps` que o container foi removido e não está mais rodando no Codespaces.*
