# Ambiente AWS reproduzível

O Terraform cria uma EC2 Ubuntu com Docker, Jenkins, SonarQube e o job `to-do-list-prod`. O bootstrap também configura o acesso GitHub via SSH e a credencial do Docker Hub.

## Recriar

Guarde fora do Git:

- token do Docker Hub;
- senha inicial do administrador Jenkins;
- chave privada SSH do GitHub com acesso ao repositório.

Na pasta `tf-aws-infra-jenkins`:

```bash
export DOCKERHUB_USERNAME=flaviovalenca
export DOCKERHUB_TOKEN='seu-token-do-dockerhub'
export JENKINS_ADMIN_PASSWORD='sua-senha-forte'
export GITHUB_SSH_PRIVATE_KEY_FILE="$HOME/.ssh/github-to-do-list"
export ALLOWED_CIDRS='SEU_IP_PUBLICO/32'
./recreate.sh
```

O script imprime o novo IP público ao terminar. Acesse Jenkins em `http://IP:8080`, SonarQube em `http://IP:9000`, desenvolvimento em `http://IP:8001` e produção em `http://IP:8000`.

Se `ALLOWED_CIDRS` não for definido, o Terraform libera as portas apenas para o IP público detectado no momento do `apply`. Para mais de um endereço, use uma lista separada por vírgulas.

## Destruir

```bash
./destroy.sh
```

O script remove a EC2, o volume raiz, o security group, o key pair e a chave `.pem` gerada localmente. O Docker Hub e o GitHub não são alterados.

## State e segredos

O state local e todos os arquivos sensíveis são ignorados por `.gitignore`. Para uso em equipe ou CI, mova o state para um backend remoto protegido e injete as variáveis como secrets do CI.