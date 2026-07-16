# LAB 10: Blocos Dinâmicos (Dynamic Blocks no Terraform)

Este laboratório prático guiará você no uso de **Blocos Dinâmicos** (`dynamic`) no Terraform. Você aprenderá como automatizar a declaração de sub-blocos de recursos repetitivos (como configurações de discos, portas ou regras de segurança), reduzindo a duplicação de código e tornando seus manifestos altamente parametrizáveis. Este laboratório será executado diretamente na **AWS Real** (AWS Academy).

---

## 🎯 Objetivos de Aprendizado
- Compreender a finalidade e a sintaxe dos blocos `dynamic` no Terraform.
- Iterar sobre uma lista de objetos para configurar múltiplos sub-recursos.
- Provisionar instâncias `EC2` com múltiplos volumes EBS (`ebs_block_device`) gerados sob demanda.

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Preparação do Ambiente
1. Certifique-se de que suas credenciais temporárias da `AWS Academy` estão ativas no arquivo `~/.aws/credentials` (conforme Passo 1 do Lab 03).

---

### Passo 2: Analisar a Estrutura no `main.tf`
Abra o arquivo `main.tf` na pasta `lab10-dynamic_blocks/` e analise a estrutura do bloco dinâmico:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0de716d6197524dd9"
  instance_type = "t2.micro"

  dynamic "ebs_block_device" {
    for_each = var.ebs_volumes
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      delete_on_termination = true
    }
  }
}
```

*   `dynamic "ebs_block_device"` cria múltiplos blocos de disco adicionados à instância EC2.
*   `for_each = var.ebs_volumes` indica qual lista de objetos deve ser percorrida.
*   O bloco `content` mapeia as propriedades de cada item iterado usando a variável especial `ebs_block_device.value.*`.

---

### Passo 3: Executar os Comandos do Terraform
No terminal do seu Codespaces, navegue para a pasta e aplique a infraestrutura:

1. **Navegar para a pasta do Lab 10:**
   ```bash
   cd lab10-dynamic_blocks
   ```
2. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```
3. **Verificar o Planejamento:**
   ```bash
   terraform plan
   ```
   > **Nota Visual:** Repare no output do planejamento que o Terraform lista uma única instância EC2, porém contendo dois blocos de disco adicionais configurados (`ebs_block_device`) conforme os valores padrão da variável `ebs_volumes`.
4. **Aplicar o Provisionamento:**
   ```bash
   terraform apply
   ```
   *Digite **`yes`** e aperte `Enter` para confirmar.*

---

## 🔍 Pontos de Validação Prática

1. **Verificar Instâncias no Console:**
   Acesse o console do Amazon EC2, selecione a instância criada ("Local Exec Example" ou sem tag name configurada) e vá na aba de **Storage (Armazenamento)**.
2. **Confirmar Volumes Adicionados:**
   Valide que a instância possui o volume raiz (geralmente `/dev/xvda`) e mais dois volumes anexados adicionais nas portas configuradas: `/dev/sdb` (com 10GB) e `/dev/sdc` (com 20GB).

---

## 🧹 Limpeza do Ambiente
Para evitar cobranças, remova a infraestrutura executando:
```bash
terraform destroy
```
*Digite **`yes`** para confirmar a destruição.*
