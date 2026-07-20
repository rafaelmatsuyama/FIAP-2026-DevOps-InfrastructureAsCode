# LAB 12: Provisionadores Remotos (Remote Exec Provisioner)

Este laboratório prático guiará você no uso do provisionador remoto (`remote-exec`) no Terraform. Você aprenderá como configurar conexões SSH para acessar recursos na nuvem recém-criados e executar comandos remotos no sistema operacional da instância (como a instalação de pacotes e inicialização de servidores web). Este laboratório será executado diretamente na **AWS Real** (AWS Academy).

---

## 🎯 Objetivos de Aprendizado
- Configurar o bloco de conexão (`connection`) SSH no Terraform utilizando chaves privadas `.pem`.
- Utilizar o provisionador `remote-exec` para gerenciar recursos remotamente.
- Instalar e inicializar o servidor web `Nginx` automaticamente na inicialização da máquina.

---

## 🏃‍♂️ Guia Passo a Passo

### Passo 1: Preparação do Ambiente e Chaves SSH
Como o Terraform fará uma conexão remota via SSH, precisamos de uma chave SSH e de regras de rede apropriadas:

1. **Localizar sua chave privada:**
   A `AWS Academy` fornece uma chave privada padrão em formato `.pem`. No diretório `lab12-remoteexec/`, certifique-se de que o arquivo `labsuser.pem` existe.
2. **Ajustar permissões da chave privada:**
   No Linux/MacOS (ou terminal do Codespaces), as chaves SSH exigem permissões estritas para funcionar. Ajuste as permissões do arquivo rodando:
   ```bash
   chmod 400 lab12-remoteexec/labsuser.pem
   ```

---

### Passo 2: Analisar a Estrutura no `main.tf`
Observe os blocos de conexão e provisionador no arquivo:

```hcl
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/labsuser.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y nginx",
      "sudo systemctl start nginx"
    ]
  }
```

*   `connection` define os detalhes de transporte SSH. O `self.public_ip` referencia automaticamente o IP público da própria instância criada.
*   `provisioner "remote-exec"` executa a lista de comandos do bloco `inline` sequencialmente no servidor remoto.

---

### Passo 3: Executar os Comandos do Terraform
No terminal do seu Codespaces, navegue para a pasta e aplique a infraestrutura:

1. **Navegar para a pasta do Lab 12:**
   ```bash
   cd lab12-remoteexec
   ```
2. **Inicializar o Terraform:**
   ```bash
   terraform init
   ```
3. **Aplicar o Provisionamento:**
   ```bash
   terraform apply
   ```
   *Digite **`yes`** e aperte `Enter` para confirmar.*
   *(Nota: O apply pode demorar um pouco mais nesta etapa, pois o Terraform aguardará a instância inicializar, estabelecerá a conexão SSH e executará o update e instalação do Nginx).*

---

## 🔍 Pontos de Validação Prática

1. **Validar o Funcionamento do Nginx:**
   Ao término da execução com sucesso, o terminal exibirá os detalhes de provisionamento. Copie o IP público da instância e cole no seu navegador:
   ```text
   http://IP_PUBLICO_DA_INSTANCIA
   ```
   *Confirme se a página de boas-vindas do Nginx é carregada.*

---

## 🧹 Limpeza do Ambiente
Para evitar cobranças acumuladas na conta de testes, destrua os recursos criados:
```bash
terraform destroy
```
*Digite **`yes`** para confirmar a destruição.*
