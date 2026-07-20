# LAB 05: Refatoração e Modularização (Criando Módulos no Terraform)

Este laboratório prático guiará você na refatoração de uma infraestrutura estática para uma arquitetura modular. Você aprenderá a criar e utilizar um módulo customizado local para encapsular a criação de servidores web (`EC2`), facilitando a reutilização de código e as boas práticas de desenvolvimento em IaC. Este laboratório será executado diretamente na **AWS Real** (AWS Academy).

---

## 🎯 Objetivos de Aprendizado
- Compreender o conceito de módulos e os benefícios de encapsulamento em Terraform.
- Declarar e passar variáveis de entrada (`variables.tf`) para um módulo.
- Expor dados gerados pelo módulo usando variáveis de saída (`outputs.tf`).
- Chamar um módulo local no manifesto principal (`main.tf`).

---

## 🏗️ Estrutura de Arquivos do Laboratório
A pasta do laboratório está estruturada da seguinte forma:
```text
lab05-refactoring/
├── main.tf                 # Manifesto principal (chama o módulo)
└── modules/
    └── ec2/                # Pasta contendo o módulo customizado de EC2
        ├── main.tf         # Declaração da instância EC2 do módulo
        ├── variables.tf    # Variáveis de entrada aceitas pelo módulo
        └── outputs.tf      # Variáveis de saída expostas pelo módulo
```

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Preparação do Ambiente
1. Certifique-se de que suas credenciais temporárias da AWS Academy ainda estão ativas no arquivo `~/.aws/credentials` (conforme Passo 1 do Lab 03).

---

### Passo 2: Entender os Arquivos do Módulo `ec2`
Navegue e analise os arquivos dentro de `modules/ec2/`:

1. **`variables.tf`**: Declara as variáveis que o módulo precisa receber do arquivo pai para poder criar a instância (ex: `ami`, `instance_type`, `security_groups` e `name`).
2. **`main.tf`**: Contém a declaração do recurso `aws_instance.example` que mapeia seus parâmetros internos aos valores das variáveis declaradas em `variables.tf` (ex: `ami = var.ami`).
3. **`outputs.tf`**: Expõe dados da instância criada para que possam ser exibidos ou consumidos por outros recursos no arquivo raiz do projeto (ex: exportando `aws_instance.example.public_ip`).

---

### Passo 3: Analisar a Chamada do Módulo no `main.tf` Raiz
Abra o arquivo `main.tf` localizado na raiz da pasta `lab05-refactoring/` e observe o bloco de chamada:

```hcl
module "ec2_instance" {
  source = "./modules/ec2"

  ami             = "ami-0de716d6197524dd9"
  instance_type   = "t2.micro"
  security_groups = ["allow_ssh_http"]
  name            = "Terraform Module Example"
}

output "instance_public_ip" {
  value = module.ec2_instance.public_ip
}
```

*Note que a linha `source = "./modules/ec2"` diz ao Terraform onde encontrar o código do módulo. Além disso, consumimos o output exposto pelo módulo usando a sintaxe `module.ec2_instance.public_ip`.*

---

### Passo 4: Executar e Provisionar a Infraestrutura

Abra o terminal do seu Codespaces e execute os comandos do ciclo de vida:

1. **Navegar para a pasta do Lab 05:**
   ```bash
   cd lab05-refactoring
   ```
2. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```
   > **Importante:** Sempre que um novo módulo local é adicionado ou modificado, o comando `terraform init` deve ser executado para que o Terraform faça o mapeamento e registro interno do módulo na pasta `.terraform/modules`.
3. **Verificar o Planejamento:**
   ```bash
   terraform plan
   ```
4. **Aplicar o Provisionamento:**
   ```bash
   terraform apply
   ```
   *Digite **`yes`** e aperte `Enter` para confirmar.*

---

## 🔍 Pontos de Validação Prática

1. **Validação do Output:**
   Ao término do `terraform apply`, verifique que o terminal imprimiu um output chamado `instance_public_ip` exibindo o endereço IP público real da máquina provisionada na AWS.
2. **Validação no Console da AWS:**
   Acesse o console do Amazon EC2 e verifique que uma nova instância foi iniciada com a tag `Name` igual a "Terraform Module Example".

---

## 🧹 Limpeza do Ambiente
Para evitar custos desnecessários na AWS Academy, remova todos os recursos provisionados executando no terminal:
```bash
terraform destroy
```
*Digite **`yes`** e confirme a destruição dos recursos.*
