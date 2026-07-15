# LAB 07: Estruturas de Repetição com Count (Criando Múltiplas Instâncias)

Este laboratório prático guiará você no uso do argumento especial `count` no Terraform. Você aprenderá como automatizar o provisionamento de múltiplos recursos idênticos a partir de um único bloco de código, utilizando variáveis de índice para diferenciar os recursos criados de forma dinâmica. Este laboratório será executado diretamente na **AWS Real** (AWS Academy).

---

## 🎯 Objetivos de Aprendizado
- Compreender o funcionamento do argumento meta `count` no Terraform.
- Provisionar múltiplas instâncias `EC2` com um único bloco de recursos declarativo.
- Utilizar a variável interna `count.index` para customizar tags e propriedades de cada recurso.

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Preparação do Ambiente
1. Certifique-se de que suas credenciais temporárias da `AWS Academy` estão ativas no arquivo `~/.aws/credentials` (conforme Passo 1 do Lab 03).

---

### Passo 2: Analisar a Estrutura no `main.tf`
Abra o arquivo `main.tf` na pasta `lab07-count/` e analise o recurso de instância:

```hcl
resource "aws_instance" "count_example" {
  count         = 3
  ami           = "ami-0de716d6197524dd9"
  instance_type = "t2.micro"

  tags = {
    Name = "Instance ${count.index + 1}"
  }
}
```

*   `count = 3` informa ao Terraform para instanciar esse bloco 3 vezes.
*   `${count.index + 1}` utiliza o índice da iteração (começando do zero) para nomear as instâncias dinamicamente como "Instance 1", "Instance 2" e "Instance 3".

---

### Passo 3: Executar os Comandos do Terraform
No terminal do seu Codespaces, navegue para a pasta e aplique a infraestrutura:

1. **Navegar para a pasta do Lab 07:**
   ```bash
   cd lab07-count
   ```
2. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```
3. **Verificar o Planejamento:**
   ```bash
   terraform plan
   ```
   > **Nota Visual:** Repare no output do planejamento que o Terraform lista 3 recursos a serem criados, identificados como `aws_instance.count_example[0]`, `aws_instance.count_example[1]` e `aws_instance.count_example[2]`.
4. **Aplicar o Provisionamento:**
   ```bash
   terraform apply
   ```
   *Digite **`yes`** e aperte `Enter` para confirmar.*

---

## 🔍 Pontos de Validação Prática

1. **Verificar Instâncias no Console:**
   Acesse o console do Amazon EC2 e valide que existem 3 novas instâncias executando com as tags de nome correspondentes: `Instance 1`, `Instance 2` e `Instance 3`.
2. **Entender a dependência do índice:**
   Se você alterar o `count = 3` para `count = 2` e rodar um `terraform apply`, note que o Terraform destruirá especificamente a instância de índice 2 (`aws_instance.count_example[2]`), mantendo as duas primeiras intactas.

---

## 🧹 Limpeza do Ambiente
Para evitar cobranças, remova a infraestrutura executando:
```bash
terraform destroy
```
*Digite **`yes`** para confirmar a destruição.*
