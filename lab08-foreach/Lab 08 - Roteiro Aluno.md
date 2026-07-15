# LAB 08: Estruturas de Repetição com For Each (Mapeamento de Instâncias)

Este laboratório prático guiará você no uso do argumento especial `for_each` no Terraform. Você aprenderá a iterar sobre coleções de dados (como listas convertidas em conjuntos ou mapas) para criar recursos de forma independente, sem as limitações de acoplamento por índice numérico do `count`. Este laboratório será executado diretamente na **AWS Real** (AWS Academy).

---

## 🎯 Objetivos de Aprendizado
- Compreender a diferença conceitual e prática entre os argumentos `count` e `for_each`.
- Utilizar conjuntos (`set`) para controle de provisionamento único.
- Mapear atributos e chaves dinâmicas usando a variável interna `each.value` e `each.key`.

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Preparação do Ambiente
1. Certifique-se de que suas credenciais temporárias da `AWS Academy` estão ativas no arquivo `~/.aws/credentials` (conforme Passo 1 do Lab 03).

---

### Passo 2: Analisar a Estrutura no `main.tf`
Abra o arquivo `main.tf` na pasta `lab08-foreach/` e analise o código:

```hcl
variable "instance_names" {
  type    = list(string)
  default = ["web1", "web2", "web3"]
}

resource "aws_instance" "foreach_example" {
  for_each      = toset(var.instance_names)
  ami           = "ami-0de716d6197524dd9"
  instance_type = "t2.micro"

  tags = {
    Name = each.value
  }
}
```

*   `for_each` exige uma coleção de chaves exclusivas. Por isso, a lista de strings `var.instance_names` é convertida em um conjunto utilizando a função `toset()`.
*   O Terraform criará uma instância para cada item do conjunto. O valor do item atual da iteração é acessado via `each.value`.

---

### Passo 3: Executar os Comandos do Terraform
No terminal do seu Codespaces, navegue para a pasta e aplique a infraestrutura:

1. **Navegar para a pasta do Lab 08:**
   ```bash
   cd lab08-foreach
   ```
2. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```
3. **Verificar o Planejamento:**
   ```bash
   terraform plan
   ```
   > **Nota Visual:** Observe que o Terraform identifica os recursos usando chaves em string em vez de índices, como `aws_instance.foreach_example["web1"]`, `aws_instance.foreach_example["web2"]` e `aws_instance.foreach_example["web3"]`.
4. **Aplicar o Provisionamento:**
   ```bash
   terraform apply
   ```
   *Digite **`yes`** e aperte `Enter` para confirmar.*

---

## 🔍 Pontos de Validação Prática

1. **Verificar Instâncias no Console:**
   Acesse o console do Amazon EC2 e valide que existem 3 novas instâncias executando com as tags de nome correspondentes: `web1`, `web2` e `web3`.
2. **Entender a independência das chaves:**
   Se você alterar a variável default no código para remover `web2` e incluir `web4` (`["web1", "web3", "web4"]`), ao rodar `terraform apply` note que o Terraform destruirá apenas `web2` e criará `web4`. O recurso `web3` não sofrerá alteração (diferente do comportamento do `count` que recriaria recursos caso mudássemos a ordem).

---

## 🧹 Limpeza do Ambiente
Para evitar cobranças, remova a infraestrutura executando:
```bash
terraform destroy
```
*Digite **`yes`** para confirmar a destruição.*
