# Oi - Cliente 360
O presente repositório desenvolvido em terraform tem o objetivo de automatizar as tarefas de provisionamento de uma infraestrutura *HUB-Spoke* e *AKS* dentro do ambiente Azure para o Cliente 360. O código foi estruturado de modo a realizar o deploy em 4 subscriptions diferentes: **CAF - Connectivity**, **CAF - Identity**, **CAF - Management** e **CLIENTE 360** sendo a primeira a localidade da *Hub* do projeto e as restantes as localidades das *Spokes*. A imagem abaixo permite visualizar melhor a topologia a ser provisionada:

![infrastructure](./.README/infrastructure.png)

Além do código desenvolvido pela Logicalis o repositório ainda contém um módulo terraform distribuido pela empresa *SAS* chamado *viya4* capaz de provisionar um ambiente AKS completo com AzureDB PostgreSQL já configurado. A documentação desse módulo pode ser acessada através do [link](https://github.com/sassoftware/viya4-iac-azure).

# Instalação
## Dependências
Somente duas dependências são necessárias, `az` e `terraform`.

Utilize os seguintes links para instruções de instalação de ambos:
 1. https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
 2. https://www.terraform.io/downloads

## Provisionamento
Utilizando a ferramenta `az` logue-se na conta correspondente as subscriptions desejadas para o deploy:

```bash
>> az login
```

Se a CLI puder abrir o navegador padrão, ela o fará e carregará uma página de entrada do Azure. Caso contrário, abra uma página de navegador em https://aka.ms/devicelogin e insira o código de autorização exibido no terminal.

Dentro do projeto copie o arquivo `terraform.tfvars.example` presente na pasta examples para a a raiz com o nome de `terraform.tfvars`. Preencha as informações necessárias no arquivo.

Com o comando abaixo inicialize os providers:

```bash
>> terraform init
```

Caso o `terraform.tfstate` já esteja localizado remotamente em uma storage account, é necessário copiar o arquivo `backend.tfvars.example` para a raiz do projeto, com o nome `backend.tfvars`, com suas respectivas variáveis preenchidas e utilizar o comando para inicialização:

```bash
>> terraform init -backend-config=backend.tfvars
```

Verifique também se o arquivo `versions.tf` está com o backend descomentado.

Utilize o comando `plan` para verificar se não existe nenhum erro e o que será provisionado.

```bash
>> terraform plan
```

Caso tudo esteja de acordo execute o comando:

```bash
>> terraform apply
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README_.md updated successfully
modules/360/README_.md updated successfully
modules/CAF-Connectivity/README_.md updated successfully
modules/CAF-Identity/README_.md updated successfully
modules/CAF-Management/README_.md updated successfully
modules/Cliente-360/README_.md updated successfully
modules/Cyber/README_.md updated successfully
modules/Oiid/README_.md updated successfully
modules/sas-viya-4/README_.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
