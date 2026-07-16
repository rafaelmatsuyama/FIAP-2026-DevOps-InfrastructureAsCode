# LAB 11: Provisionadores Locais (Local Exec Provisioner)

Este laboratório prático guiará você no uso do provisionador local (`local-exec`) no Terraform. Você aprenderá como acionar a execução de comandos, scripts ou integrações na sua própria máquina de controle (ou terminal do Codespaces) após a criação bem-sucedida de um recurso na nuvem. Este laboratório será executado diretamente na **AWS Real** (AWS Academy).

---

## 🎯 Objetivos de Aprendizado
- Compreender a finalidade e as limitações dos provisionadores no Terraform.
- Configurar o provisionador `local-exec` dentro de um recurso declarativo.
- Executar comandos do sistema operacional local para persistir dados pós-provisionamento.

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Preparação do Ambiente
1. Certifique-se de que suas credenciais temporárias da `AWS Academy` estão ativas no arquivo `~/.aws/credentials` (conforme Passo 1 do Lab 03).

---

### Passo 2: Analisar a Estrutura no `main.tf`
Abra o arquivo `main.tf` na pasta `lab11-localexec/` e observe o bloco de provisionamento:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0de716d6197524dd9"
  instance_type = "t2.micro"

  tags = {
    Name = "Local Exec Example"
  }

  provisioner "local-exec" {
    command = "echo 'Instância criada com sucesso!' > instance_info.txt"
  }
}
```

*   `provisioner "local-exec"` executa o shell script local assim que a instância atinge o estado de criação concluída.
*   `command` define a instrução literal do terminal que será invocada.

---

### Passo 3: Executar os Comandos do Terraform
No terminal do seu Codespaces, navegue para a pasta e aplique a infraestrutura:

1. **Navegar para a pasta do Lab 11:**
   ```bash
   cd lab11-localexec
   ```
2. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```
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

1. **Confirmar Execução Local:**
   Ao término do `terraform apply`, verifique a lista de arquivos do seu diretório atual no Codespaces executando:
   ```bash
   ls -la
   ```
2. **Validar Conteúdo do Arquivo:**
   Confirme se um novo arquivo chamado `instance_info.txt` foi gerado localmente e inspecione seu conteúdo com:
   ```bash
   cat instance_info.txt
   ```
   *O arquivo deve exibir o texto: "Instância criada com sucesso!".*

---

## 🧹 Limpeza do Ambiente
Para evitar cobranças, remova a infraestrutura executando:
```bash
terraform destroy
```
*Digite **`yes`** para confirmar a destruição.*
*Nota: A destruição do recurso não remove automaticamente o arquivo local `instance_info.txt`, sendo necessário apagá-lo manualmente via `rm instance_info.txt` se desejar limpar o diretório.*
