#!/usr/bin/env bash
set -euo pipefail

: "${DOCKERHUB_USERNAME:?Defina DOCKERHUB_USERNAME}"
: "${DOCKERHUB_TOKEN:?Defina DOCKERHUB_TOKEN}"
: "${JENKINS_ADMIN_PASSWORD:?Defina JENKINS_ADMIN_PASSWORD}"
: "${GITHUB_SSH_PRIVATE_KEY_FILE:?Defina GITHUB_SSH_PRIVATE_KEY_FILE apontando para a chave privada do GitHub}"

if [[ ! -f "$GITHUB_SSH_PRIVATE_KEY_FILE" ]]; then
  echo "Arquivo de chave não encontrado: $GITHUB_SSH_PRIVATE_KEY_FILE" >&2
  exit 1
fi

export TF_VAR_dockerhub_username="$DOCKERHUB_USERNAME"
export TF_VAR_dockerhub_token="$DOCKERHUB_TOKEN"
export TF_VAR_jenkins_admin_password="$JENKINS_ADMIN_PASSWORD"
export TF_VAR_github_ssh_private_key_base64="$(base64 < "$GITHUB_SSH_PRIVATE_KEY_FILE" | tr -d '\n')"

if [[ -n "${ALLOWED_CIDRS:-}" ]]; then
  export TF_VAR_allowed_cidrs="[\"${ALLOWED_CIDRS//,/\",\"}\"]"
fi

terraform init
terraform apply -auto-approve
terraform output -raw public_ip
