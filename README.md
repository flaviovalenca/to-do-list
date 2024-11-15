# Jenkins Deployment Guide

Este repositório contém todas as instruções para configurar o servidor Jenkins, integrar com GitHub e DockerHub, configurar o primeiro job e realizar um scan de vulnerabilidades com Trivy.

## Sumário

- [Pré-requisitos](#pré-requisitos)
- [Build da Imagem do Servidor Jenkins](#build-da-imagem-do-servidor-jenkins)
- [Start do Container Jenkins](#start-do-container-jenkins)
- [Configuração do Primeiro Job](#configuração-do-primeiro-job)
- [Integração com DockerHub](#integração-com-dockerhub)
- [Deploy da Aplicação no DockerHub](#deploy-da-aplicação-no-dockerhub)
- [Instalação do SonarQube](#instalação-do-sonarqube)
- [Instalação do Trivy para Scan de Vulnerabilidades](#instalação-do-trivy-para-scan-de-vulnerabilidades)

## Pré-requisitos

1. Acesso ao servidor Jenkins.
2. Conta no DockerHub com token de acesso.
3. Acesso ao repositório GitHub onde os arquivos do projeto estão armazenados.
4. Docker e Docker Compose instalados no servidor.

---

## Build da Imagem do Servidor Jenkins

Com o arquivo Dockerfile neste repositório, vamos enviar ele para o servidor Jenkins e realizar o build da imagem.

### Passos:

1. Enviar o arquivo Dockerfile para o servidor Jenkins:
    ```bash
    scp -i ../tf-aws-infra-jenkins/jenkins.pem -r Dockerfile ubuntu@<endereco-do-servidor-jenkins>:/home/ubuntu
    ```

2. Logar no servidor Jenkins:
    ```bash
    ssh -i ../tf-aws-infra-jenkins/jenkins.pem ubuntu@<endereco-do-servidor-jenkins>
    ```

3. Fazer o build da imagem Jenkins:
    ```bash
    docker build -t jenkins .
    ```

---

## Start do Container Jenkins

1. Iniciar o container Jenkins:
    ```bash
    docker run -d -p 8080:8080 --name jenkins -v /var/run/docker.sock:/var/run/docker.sock jenkins
    ```

2. Validar que o container está em execução:
    ```bash
    docker ps
    ```

3. Criar o par de chaves SSH para integração com GitHub:
    - Logar no container do Jenkins:
        ```bash
        docker exec -it jenkins bash
        ```
    - Gerar o par de chaves:
        ```bash
        ssh-keygen
        ```

---

## Configuração do Primeiro Job

1. Adicionar a chave SSH ao GitHub para o servidor Jenkins.
2. Testar a conexão SSH no container Jenkins.
3. Criar a chave do servidor no GitHub para o commit do Dockerfile.
4. Fazer o commit do Dockerfile no repositório:
    ```bash
    scp -i ../tf-aws-infra-jenkins/jenkins.pem -r Dockerfile ubuntu@<ip-do-servidor-jenkins>:/home/jenkins
    ```
5. Criar uma nova tarefa no Jenkins e realizar o primeiro build de teste.

---

## Integração com DockerHub

1. Acessar o DockerHub e gerar um token de acesso.
2. Configurar o token de acesso no job do Jenkins.
3. Atualizar o Jenkinsfile para incluir o push da imagem base.
4. Executar a pipeline e verificar se o push foi bem-sucedido.

---

## Deploy da Aplicação no DockerHub

1. Enviar os arquivos da aplicação para o servidor Jenkins.
2. Fazer o upload dos arquivos para o GitHub.
3. Iniciar o build de imagem da aplicação e confirmar que a imagem foi atualizada no DockerHub.

---

## Configuração do Ambiente da Aplicação

1. Instalar o plugin Config File no Jenkins para gerenciamento de variáveis de ambiente.
2. Atualizar o Jenkinsfile para usar o Config File (atualizar o ID do Config File conforme necessário).
3. Acessar a aplicação pelo navegador para verificar a instalação.

---

## Instalação do SonarQube

As instruções para instalação do SonarQube estão no diretório `6_install_sonarqube` deste repositório. Siga as etapas descritas lá para configurar o SonarQube no ambiente Jenkins.

---

## Instalação do Trivy para Scan de Vulnerabilidades

1. Instalar o Trivy no container do Jenkins:
    ```bash
    apt-get install wget apt-transport-https gnupg lsb-release -y
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -
    echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | tee -a /etc/apt/sources.list.d/trivy.list
    apt-get update -y && apt-get install trivy -y
    ```

2. Executar um scan de vulnerabilidades manual no Ubuntu 24.04.

3. Criar uma pipeline separada para o scan de vulnerabilidades.
