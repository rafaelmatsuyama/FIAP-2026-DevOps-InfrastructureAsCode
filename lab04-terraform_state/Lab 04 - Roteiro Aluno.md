# LAB 04: Gerenciamento de Estado Remoto (S3 Backend & State Locking)

Este laboratório prático guiará você na migração do arquivo de estado (`state`) do Terraform de local para um ambiente remoto seguro utilizando um **Bucket S3** (para armazenamento do estado) e uma tabela **DynamoDB** (para bloqueio de estado / State Locking) na **AWS Real** (AWS Academy).

---

## 🎯 Objetivos de Aprendizado
- Compreender a importância do estado remoto e do bloqueio de estado em times de engenharia.
- Configurar e inicializar um backend remoto S3 com DynamoDB no Terraform.
- Executar a esteira de migração de estado (`init -migrate-state`).
- Aprender a lidar com políticas de proteção de ciclo de vida de recursos (`prevent_destroy`).

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Preparação do Ambiente
1. Certifique-se de que configurou as credenciais da AWS no arquivo `~/.aws/credentials` (conforme Passo 1 do Lab 03).
2. Como os nomes dos buckets do S3 na AWS devem ser **globalmente exclusivos**, substitua o sufixo `-rafael-matsuyama123` no arquivo `main.tf` (linha 15) e no arquivo `backend.tf` (linha 3) por um identificador exclusivo seu (ex: `-seu-nome-seu-sobrenome`) para evitar erros de criação.

---

### Passo 2: Executar a Primeira Fase (Sem Backend Remoto)
Como o bucket S3 e a tabela do DynamoDB que armazenarão o estado remoto ainda não existem, precisamos criá-los primeiro usando o estado local.

1. **Renomeie o arquivo `backend.tf`** para `backend.tf.disabled` (para que o Terraform ignore a configuração de backend remoto temporariamente):
   ```bash
   cd labs/lab04-terraform_state
   mv backend.tf backend.tf.disabled
   ```
2. **Inicialize o diretório de trabalho** (isso baixará os provedores usando estado local):
   ```bash
   terraform init
   ```
3. **Provisione os recursos de suporte** (S3 Bucket e DynamoDB):
   ```bash
   terraform apply
   ```
   *Digite **`yes`** para confirmar. O bucket e a tabela DynamoDB serão criados.*

---

### Passo 3: Configurar e Habilitar o Backend Remoto

Agora que os recursos de backend já existem fisicamente, podemos habilitar e migrar nosso estado para lá.

1. **Configure o arquivo de backend:**
   Abra o arquivo `backend.tf.disabled` e certifique-se de que o nome do bucket (linha 3) coincide exatamente com o nome exclusivo que você definiu para o seu bucket S3 no arquivo `main.tf`. Em seguida, salve o arquivo.
2. **Renomeie o arquivo de volta para ativar o backend remoto:**
   ```bash
   mv backend.tf.disabled backend.tf
   ```
3. **Execute a inicialização de migração:**
   No terminal, execute:
   ```bash
   terraform init
   ```
4. **Confirme a Migração:**
   O Terraform detectará a mudança de backend e exibirá a seguinte mensagem:
   > *Do you want to copy existing state to the new backend?*
   
   Digite **`yes`** e aperte `Enter`. 
   
   *O Terraform copiará o arquivo `terraform.tfstate` local para dentro do bucket S3 criado.*

---

## 🔍 Pontos de Validação Prática

1. **Estado Local Esvaziado:**
   Inspecione o arquivo local `terraform.tfstate` no seu diretório de arquivos. Note que ele agora está praticamente vazio de recursos, contendo apenas um redirecionamento de metadados para o backend remoto.
2. **Validação do Lock no DynamoDB:**
   Rode um `terraform plan`. Durante a execução do comando, note que o Terraform exibe a mensagem de que está obtendo um lock no estado remoto (*Acquiring state lock*). Isso impede que outros desenvolvedores rodem comandos simultaneamente.

---

## 🧹 Limpeza e Destruição (Atenção redobrada!)

Como o bucket S3 e a tabela DynamoDB possuem travas de segurança, siga rigorosamente a sequência de passos abaixo para destruir os recursos sem erros:

### 1. Remover a Trava de Ciclo de Vida (`prevent_destroy`)
1. Abra o arquivo `main.tf` no editor.
2. Mude `prevent_destroy = true` para `prevent_destroy = false` nas linhas 24 e 45 (ou remova os blocos `lifecycle` de ambos os recursos).
3. Salve o arquivo.

### 2. Reverter para o Backend Local
Como vamos destruir o próprio bucket do S3 onde o estado remoto está gravado, não podemos executar a destruição enquanto dependermos dele como backend ativo.
1. Renomeie o arquivo `backend.tf` de volta para `backend.tf.disabled`:
   ```bash
   mv backend.tf backend.tf.disabled
   ```
2. Execute a migração do estado de volta para a máquina local:
   ```bash
   terraform init -migrate-state
   ```
   *Digite **`yes`** e aperte `Enter` para confirmar. O Terraform moverá o arquivo de estado de volta para o diretório local e, com isso, esvaziará o bucket S3 automaticamente.*

### 3. Executar a Destruição Total
Agora que o estado está local e o bucket S3 está vazio, execute a destruição:
```bash
terraform destroy
```
*Digite **`yes`** para confirmar. Todos os recursos serão apagados com sucesso.*
