# Estudo rapido sobre Terraform

## Ideia central

Terraform e uma ferramenta de Infraestrutura como Codigo (IaC). Em vez de criar recursos manualmente pelo console da nuvem, a infraestrutura desejada e descrita em arquivos `.tf`, usando HCL (HashiCorp Configuration Language). A partir desses arquivos, o Terraform calcula o que precisa ser criado, alterado ou removido para que a nuvem fique igual ao codigo.

## Pontos principais das referencias

### IBM - O que e Terraform

- Terraform permite criar, alterar e versionar infraestrutura com seguranca e eficiencia.
- A abordagem e declarativa: descreve-se o estado final esperado, e a ferramenta calcula como chegar nele.
- A IaC melhora velocidade, confiabilidade, experimentacao e reduz desvio de configuracao.
- Providers conectam o Terraform a plataformas como AWS, Azure, Google Cloud, Kubernetes e outras APIs.
- Modulos ajudam a organizar configuracoes reutilizaveis.

### HashiCorp - Infrastructure as Code

- IaC usa arquivos de configuracao em vez de cliques em interfaces graficas.
- O workflow basico e: escopo, autoria, inicializacao, planejamento e aplicacao.
- O arquivo de estado registra os recursos reais para que o Terraform consiga comparar o que existe com o que esta declarado.
- Versionar o codigo de infraestrutura permite colaboracao e auditoria, como em desenvolvimento de software.

### HashiCorp - Instalar CLI

- O Terraform e distribuido como uma CLI.
- No Windows, pode ser instalado por gerenciador de pacotes ou manualmente com o binario `.exe`.
- Depois da instalacao, o comando `terraform -version` confirma a versao disponivel.

### HashiCorp - Criar infraestrutura na AWS

- O tutorial cria uma instancia EC2 usando o provider AWS.
- A configuracao minima envolve: bloco `terraform`, provider `aws`, data source para AMI e recurso `aws_instance`.
- Antes de criar recursos, o fluxo recomendado e executar `terraform fmt`, `terraform init`, `terraform validate`, `terraform plan` e `terraform apply`.
- Credenciais AWS sao necessarias para consultar AMIs e provisionar os recursos.

## Como este trabalho foi alem do tutorial

O tutorial oficial cria uma EC2 simples. Nesta entrega, a configuracao foi organizada com variaveis, outputs, tags padronizadas e uma rede propria na AWS:

- VPC dedicada.
- Subnet publica.
- Internet Gateway.
- Route Table publica.
- Security Group para HTTP e SSH opcional.
- Instancia EC2 Ubuntu com Nginx instalado por `user_data`.
- Outputs para facilitar a validacao do ambiente provisionado.

## Referencias usadas

- https://www.ibm.com/br-pt/topics/terraform
- https://www.youtube.com/watch?v=0EAjJe8aPkc
- https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code
- https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
- https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-create
