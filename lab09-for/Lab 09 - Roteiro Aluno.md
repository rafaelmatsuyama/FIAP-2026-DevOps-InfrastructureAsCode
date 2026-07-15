# LAB 09: Expressões Avançadas com Loops For (Transformações de Dados)

Este laboratório prático guiará você no uso de loops `for` no Terraform para realizar transformações e processamentos complexos de dados. Você aprenderá como ler uma lista ou mapa de configurações locais, transformar essas estruturas dinamicamente em novos formatos e passá-las para os recursos de infraestrutura. Este laboratório será executado diretamente na **AWS Real** (AWS Academy).

---

## 🎯 Objetivos de Aprendizado
- Compreender a sintaxe e o uso das expressões com loops `for` no HCL.
- Transformar mapas chave-valor em listas de objetos e vice-versa usando expressões inline.
- Associar múltiplos tipos de recursos (`t2.micro`, `t2.small`, `t2.medium`) a instâncias dinamicamente.

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Preparação do Ambiente
1. Certifique-se de que suas credenciais temporárias da `AWS Academy` estão ativas no arquivo `~/.aws/credentials` (conforme Passo 1 do Lab 03).

---

### Passo 2: Analisar a Estrutura no `main.tf`
Abra o arquivo `main.tf` na pasta `lab09-for/` e analise a seção `locals`:

```hcl
locals {
  instance_types = {
    web1 = "t2.micro"
    web2 = "t2.small"
    web3 = "t2.medium"
  }

  instance_list = [for name, type in local.instance_types : {
    name = name
    type = type
  }]
}
```

*   `instance_types` é um mapa mapeando nomes de servidores a tipos de instância correspondentes.
*   `instance_list` utiliza uma expressão `for` para percorrer o mapa `instance_types` e construir uma lista de objetos contendo chaves `name` e `type`.

Observe também a declaração do recurso principal:
```hcl
resource "aws_instance" "for_example" {
  for_each      = {for instance in local.instance_list : instance.name => instance}
  ami           = "ami-0de716d6197524dd9"
  instance_type = each.value.type

  tags = {
    Name = each.key
  }
}
```
*   O `for_each` realiza uma transformação reversa de lista de objetos para mapa (usando `instance.name` como chave exclusiva), mapeando o valor do recurso.
*   Consumimos as propriedades dinâmicas: o tipo de instância é definido por `each.value.type` e o nome da tag pelo `each.key`.

---

### Passo 3: Executar os Comandos do Terraform
No terminal do seu Codespaces, navegue para a pasta e aplique a infraestrutura:

1. **Navegar para a pasta do Lab 09:**
   ```bash
   cd lab09-for
   ```
2. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```
3. **Verificar o Planejamento:**
   ```bash
   terraform plan
   ```
   > **Dica Visual:** No output do `terraform plan`, verifique como cada uma das instâncias possui atributos diferenciados, como tipos `t2.micro`, `t2.small` e `t2.medium` associados aos nomes correspondentes.
4. **Aplicar o Provisionamento:**
   ```bash
   terraform apply
   ```
   *Digite **`yes`** e aperte `Enter` para confirmar.*

---

## 🔍 Pontos de Validação Prática

1. **Verificar Instâncias no Console:**
   Acesse o Console do EC2 e valide que 3 instâncias foram criadas com os nomes (`web1`, `web2`, `web3`) e seus respectivos tipos de instância (`t2.micro`, `t2.small`, `t2.medium`).
2. **Experimentar Alterações:**
   Adicione um quarto item ao bloco local `instance_types` (ex: `web4 = "t2.micro"`). Execute um `terraform plan` e note que a infraestrutura se adapta dinamicamente criando a nova instância mapeada na lista.

---

## 🧹 Limpeza do Ambiente
Para evitar cobranças, remova a infraestrutura executando:
```bash
terraform destroy
```
*Digite **`yes`** para confirmar a destruição.*
