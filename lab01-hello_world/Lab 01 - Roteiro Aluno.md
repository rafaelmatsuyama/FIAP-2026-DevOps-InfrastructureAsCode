# LAB 01: Meu Primeiro Provisionamento (Codespaces + Hello World)

Este laboratório prático guiará você na sua primeira experiência com **Infrastructure as Code (IaC)** utilizando o **Terraform** no ambiente em nuvem do **GitHub Codespaces**.

---

## 🎯 Objetivos de Aprendizado
- Compreender e executar o ciclo de vida básico do Terraform (`init`, `plan`, `apply`, `destroy`).
- Entender a abordagem declarativa e a idempotência em IaC.
- Analisar o arquivo de estado local (`terraform.tfstate`) criado pelo Terraform.

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Abrir o Ambiente no GitHub Codespaces
1. Faça login na sua conta no [GitHub](https://github.com).
2. Acesse um repositório público da disciplina [MBA DevOps - Infrastructure as Code](https://github.com/rafaelmatsuyama/FIAP-2026-DevOps-InfrastructureAsCode).
3. No repositório, clique no botão verde **Code** -> selecione a aba **Codespaces** -> clique em **Create codespace on main**.
4. Aguarde alguns instantes até que a interface do VS Code seja renderizada no seu navegador.

> [!TIP]
> **Troubleshooting (Caso o Terraform não esteja instalado):**
> Se ao rodar os comandos nos passos seguintes você receber o erro `bash: terraform: command not found`, execute o bloco de comandos abaixo no terminal do seu Codespaces para instalá-lo em segundos:
> ```bash
> wget https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip
> unzip terraform_1.9.0_linux_amd64.zip
> sudo mv terraform /usr/local/bin/
> rm terraform_1.9.0_linux_amd64.zip
> ```

### Passo 2: Criar o Arquivo de Configuração do Terraform
1. No gerenciador de arquivos lateral esquerdo, clique com o botão direito sobre a subpasta **`lab01-hello_world`**, selecionando **New File** (Novo Arquivo).
2. Dê o nome de **`main.tf`** para este arquivo (ele deve residir dentro da pasta do laboratório).
3. Copie e cole o seguinte código HCL dentro do arquivo:

```hcl
# 1. Definição dos providers locais (não exigem chaves ou nuvem real)
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

# 2. Recurso: Gerador de string aleatória (simulando um sufixo exclusivo)
resource "random_id" "unique_suffix" {
  byte_length = 4
}

# 3. Recurso: Criador de arquivo texto local no servidor
resource "local_file" "hello_fiap" {
  content  = "Olá, Turma do MBA de DevOps! Seu identificador exclusivo de infraestrutura é: ${random_id.unique_suffix.hex}\n"
  filename = "${path.module}/hello_world.txt"
}
```

### Passo 3: Executar os Comandos do Terraform
Abra o terminal integrado do VS Code (atalho `Ctrl + '` ou pelo menu principal Terminal -> New Terminal) e execute os seguintes comandos sequencialmente:

1.  **Navegação e Inicialização do Diretório:**
    No terminal, primeiro navegue para a pasta do laboratório:
    ```bash
    cd lab01-hello_world
    ```
    Em seguida, inicialize o Terraform para baixar os providers:
    ```bash
    terraform init
    ```
    *Este comando lê o manifesto `main.tf`, identifica os providers necessários (`local` e `random`) e faz o download automático dos plugins correspondentes.*

2.  **Planejamento das Alterações:**
    ```bash
    terraform plan
    ```
    *Este comando compara o código com o estado atual e desenha um plano de ação, mostrando exatamente o que será criado, modificado ou destruído.*

3.  **Aplicação do Plano:**
    ```bash
    terraform apply
    ```
    *Digite **`yes`** e aperte `Enter` quando o terminal solicitar a confirmação para aplicar as mudanças.*

---

## 🔍 Pontos de Validação Prática

1.  **Verifique os Arquivos Gerados:** Note que um arquivo chamado `hello_world.txt` surgiu na sua pasta de arquivos. Abra-o e veja o identificador aleatório criado.
2.  **Verifique o Estado do Terraform:** Abra o arquivo `terraform.tfstate` que foi gerado automaticamente. Note que ele é um JSON estruturado contendo os metadados dos recursos reais criados.
3.  **Idempotência:** Execute o comando `terraform apply` novamente. Note que o Terraform dirá que nenhuma alteração foi necessária, pois o estado atual já corresponde ao desejado.

---

## 🧹 Limpeza do Ambiente
Para desprovisionar os recursos criados e encerrar o ciclo, execute no terminal (certifique-se de que ainda está na pasta `lab01-hello_world`):
```bash
terraform destroy
```
*Digite **`yes`** e aperte `Enter` para confirmar. Verifique que o arquivo `hello_world.txt` sumiu instantaneamente do diretório.*
